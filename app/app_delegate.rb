
class AppDelegate

  def application application, didFinishLaunchingWithOptions:launchOptions
    lists_view_controller = ListsViewController.alloc.initWithNibName(nil, bundle: nil)
    navigation_controller = UINavigationController.alloc.initWithRootViewController(lists_view_controller)

    @window = UIWindow.alloc.initWithFrame UIScreen.mainScreen.bounds
    @window.makeKeyAndVisible
    @window.rootViewController = navigation_controller

    true
  end

end
