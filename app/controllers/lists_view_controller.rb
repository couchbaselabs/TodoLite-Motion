class ListsViewController < UIViewController

  def viewDidLoad
    self.navigationItem.title = "Todo Lists"

    navigationItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemAdd, target:self, action:"add_list")
    navigationItem.leftBarButtonItem = UIBarButtonItem.alloc.initWithCustomView(login_button)

    @lists_table = UITableView.alloc.initWithFrame(view.bounds)

    self.view.addSubview @lists_table
    # TODO setup table view for lists
  end


  def login_button
    @login_button ||= UIButton.buttonWithType(UIButtonTypeSystem).tap do |button|
      button.frame = [[0, 0], [50, navigationController.navigationBar.frame.size.height]]
      button.setTitle "Login", forState:UIControlStateNormal
      button.addTarget self, action:"login", forControlEvents:UIControlEventTouchUpInside
    end
  end

  def add_list
    # TODO add new list to database
  end

  def login
    facebook_sync_authenticator.credentials { |user_id, info| setup_replication user_id, info }
  end

  def setup_replication user_id, info
    puts user_id, info
  end

  def facebook_sync_authenticator
    @facebook_sync_authenticator ||= FacebookSyncAuthenticator.new(Config::Facebook::APP_ID, sync_manager)
  end

  def sync_manager
    @sync_manager ||= SyncManager.new
  end
end
