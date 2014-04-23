
class AppDelegate

  def application application, didFinishLaunchingWithOptions:launchOptions
    @lists_view_controller = ListsViewController.alloc.init
    @lists_view_controller.database = database
    @navigation_controller = UINavigationController.alloc.initWithRootViewController(@lists_view_controller)
    @lists_view_controller.navigation_controller = @navigation_controller

    @window = UIWindow.alloc.initWithFrame UIScreen.mainScreen.bounds
    @window.makeKeyAndVisible
    @window.rootViewController = @navigation_controller

    database.modelFactory.registerClass(List.class, forDocumentType:"list")
    database.modelFactory.registerClass(Task.class, forDocumentType:"item")

    login_and_setup_sync

    true
  end

  def database
    return @database if @database

    manager = CBLManager.sharedInstance
    error_ptr = Pointer.new(:object)
    @database = manager.databaseNamed("todos", error: error_ptr)
    unless @database
      error = error_ptr[0]
      alert = UIAlertView.alloc.initWithTitle("Local Database Error",
                                              message:"No access to local database. #{error}",
                                              delegate:nil,
                                              cancelButtonTitle:"Ok",
                                              otherButtonTitles: nil)
      alert.show
    else
      @database
    end
  end

  def login_and_setup_sync
    facebook_sync_authenticator.credentials do |user_id, info|
      @lists_view_controller.user_id = user_id
      profile = Profile.alloc.initCurrentUserProfileInDatabase @database, withName:info["username"], andUserID:user_id
      sync_manager.authenticator = facebook_sync_authenticator
      sync_manager.start_replication
    end
  end

  def facebook_sync_authenticator
    @facebook_sync_authenticator ||= FacebookSyncAuthenticator.new(Config::Facebook::APP_ID, sync_manager)
  end

  def sync_manager
    @sync_manager ||= SyncManager.new(database)
  end

end
