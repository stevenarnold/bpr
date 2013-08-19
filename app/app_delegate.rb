class AppDelegate
  extend IB

  outlet :window, UIWindow
  attr_accessor :sb, :settings, :ambient, :binaural, :navigationController

  def initialize_sound
    # sessionCategory = kAudioSessionCategory_MediaPlayback;
    # AudioSessionSetProperty(
    #     kAudioSessionProperty_AudioCategory,
    #     sizeof (sessionCategory),
    #     &sessionCategory
    # );
  end

  def get_ambient_picker
    myPickerView = UIPickerView.alloc.initWithFrame(CGRectMake(0, 200, 320, 200))
    myPickerView.delegate = @bc_controller
    myPickerView.showsSelectionIndicator = true
    myPickerView.tag = @ambient
    myPickerView
  end

  def change_to_picker(key, value)
    # Load the default values for the user defaults
    pathToUserDefaultsValues = NSBundle.mainBundle.
                                        pathForResource("userDefaults", ofType:"plist")
    userDefaultsValues = NSDictionary.dictionaryWithContentsOfFile(pathToUserDefaultsValues) || 
                         NSDictionary.dictionaryWithObject(value, forKey:key)

    # Set them in the standard user defaults
    puts "as01"
    # NSUserDefaults.standardUserDefaults.registerDefaults(userDefaultsValues)
    puts "as02"
  end

  # Might need to implement 'dismiss' to capture the actual settings in our app
  def settingsViewControllerDidEnd(sender)
    @bc_controller.show_view(@navigationController.view, @bc_controller)
  end

  def settingDidChange
    alert("notice", "Settings changed")
# - (void)settingDidChange:(NSNotification*)notification {
# if ([notification.object isEqual:@"AutoConnect"]) {
# IASKAppSettingsViewController *activeController = self.tabBarController.selectedIndex ? self.tabAppSettingsViewController : self.appSettingsViewController;
# BOOL enabled = (BOOL)[[notification.userInfo objectForKey:@"AutoConnect"] intValue];
# [activeController setHiddenKeys:enabled ? nil : [NSSet setWithObjects:@"AutoConnectLogin", @"AutoConnectPassword", nil] animated:YES];
# }
# }
  end

  def userDefaultsDidChange
    App.alert("user defaults changed.  binauralVolume = #{NSUserDefaults.standardUserDefaults.integerForKey('binauralVolume')}")
  end

  def alert(title, message)
    UIAlertView.alloc.initWithTitle(title, 
                                    message: message,
                                    delegate: nil,
                                    cancelButtonTitle: "OK",
                                    otherButtonTitles: nil).show
  end

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    NSNotificationCenter.defaultCenter.addObserver(self, 
                                                   selector: "settingDidChange", 
                                                   name: "kAppSettingChanged",
                                                   object: nil)
    App.notification_center.addObserver(self,
                                        selector: "userDefaultsDidChange",
                                        name: NSUserDefaultsDidChangeNotification,
                                        object: NSUserDefaults.standardUserDefaults)
    @ambient = 0
    @binaural = 1
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.makeKeyAndVisible
    @sb = UIStoryboard.storyboardWithName("Storyboard", bundle: nil)
    @settings = IASKAppSettingsViewController.alloc.initWithNibName("IASKAppSettingsView", bundle: nil)
    puts "@settings = #{@settings}"
    puts "@settings.view = #{@settings.view}"
    initialize_sound
    @navigationController = UINavigationController.alloc.initWithRootViewController(@settings)
    @bc_controller = @window.rootViewController = @sb.instantiateViewControllerWithIdentifier("beat_counter")
    indexPath = NSIndexPath.indexPathForRow(2, inSection:0)
    puts "indexPath = #{indexPath}"
    puts "numberOfRowsInSection:0 = #{@settings.tableView.numberOfRowsInSection(0)}"
    puts "numberOfRowsInSection:0 = #{@settings.tableView.numberOfRowsInSection(1)}"
    cell = @settings.tableView.cellForRowAtIndexPath(indexPath)
    textfield = cell.contentView.subviews[1]  # .viewWithTag(@ambient)
    textfield.inputView = get_ambient_picker
  end
end
