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

  def settingsViewControllerDidEnd(sender)
    @bc_controller.show_view(@navigationController.view, @bc_controller)
  end

  # def settingDidChange
  #   alert("notice", "Settings changed")
  # end

  def userDefaultsDidChange
    # App.alert("user defaults changed.  binauralVolume = #{NSUserDefaults.standardUserDefaults.integerForKey('binauralVolume')}")
    @bc_controller.initialize_defaults
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
    @defaults = NSUserDefaults.standardUserDefaults
    puts "@settings = #{@settings}"
    puts "@settings.view = #{@settings.view}"
    initialize_sound
    @navigationController = UINavigationController.alloc.initWithRootViewController(@settings)
    @bc_controller = @window.rootViewController = @sb.instantiateViewControllerWithIdentifier("beat_counter")
    userDefaultsDidChange
  end
end
