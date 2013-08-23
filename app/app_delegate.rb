class AppDelegate
  extend IB
  include SoundHelper

  outlet :window, UIWindow
  attr_accessor :sb, :settings, :ambient, :binaural, :navigationController,
                :bc_controller, :defaults

  def initialize_sound
    # sessionCategory = kAudioSessionCategory_MediaPlayback;
    # AudioSessionSetProperty(
    #     kAudioSessionProperty_AudioCategory,
    #     sizeof (sessionCategory),
    #     &sessionCategory
    # );
  end

  def row_for_sound(sound)
    case sound
    when 'rain'
      0
    when 'ocean'
      1
    when 'forest'
      2
    else
      0
    end
  end

  def get_ambient_picker
    myPickerView = UIPickerView.alloc.initWithFrame(CGRectMake(0, 200, 320, 200))
    myPickerView.delegate = @bc_controller
    myPickerView.showsSelectionIndicator = true
    myPickerView.tag = @ambient
    myPickerView.selectRow(row_for_sound(@defaults.objectForKey('ambientProgram')), inComponent: 0, animated: true)
    myPickerView
  end

  def settingsViewControllerDidEnd(sender)
    @bc_controller.show_view(@navigationController.view, @bc_controller)
  end

  # def settingDidChange
  #   alert("notice", "Settings changed")
  # end

  def userDefaultsDidChange
    # App.alert("user defaults changed.  binauralVolume = #{NSUserDefaults.standardUserDefaults.integerForKey('binauralVolume')}")
    @bc_controller.initialize_defaults(@bc_controller, @defaults)
  end

  def prepare_picker
  end

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    # NSNotificationCenter.defaultCenter.addObserver(self, 
    #                                                selector: "settingDidChange", 
    #                                                name: "kAppSettingChanged",
    #                                                object: nil)
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
    @defaults = NSUserDefaults.standardUserDefaults
    userDefaultsDidChange
    cell = @settings.tableView.cellForRowAtIndexPath(indexPath)
    puts "cell = #{cell}"
    puts "label = #{cell.contentView.subviews[0]}"
    textfield = cell.contentView.subviews[1]  # .viewWithTag(@ambient)
    textfield.inputView = get_ambient_picker
  end
end
