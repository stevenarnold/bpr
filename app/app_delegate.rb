class AppDelegate
  extend IB

  outlet :window, UIWindow
  attr_accessor :sb, :settings, :ambient, :binaural

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

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @ambient = 0
    @binaural = 1
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.makeKeyAndVisible
    @sb = UIStoryboard.storyboardWithName("Storyboard", bundle: nil)
    @settings = IASKAppSettingsViewController.alloc.initWithNibName("IASKAppSettingsView", bundle: nil)
    puts "@settings = #{@settings}"
    puts "@settings.view = #{@settings.view}"
    indexPath = NSIndexPath.indexPathForRow(3, inSection:0)
    puts "indexPath = #{indexPath}"
    puts "numberOfRowsInSection:0 = #{@settings.tableView.numberOfRowsInSection(0)}"
    puts "numberOfRowsInSection:0 = #{@settings.tableView.numberOfRowsInSection(1)}"
    cell = @settings.tableView.cellForRowAtIndexPath(indexPath)
    textfield = cell.contentView.subviews[1]  # .viewWithTag(@ambient)
    textfield.inputView = get_ambient_picker
    initialize_sound
    @bc_controller = @window.rootViewController = @sb.instantiateViewControllerWithIdentifier("beat_counter")
  end
end
