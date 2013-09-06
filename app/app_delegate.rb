class AppDelegate
  extend IB
  include SoundHelper

  outlet :window, UIWindow
  attr_accessor :sb, :settings, :ambient, :binaural, :navigationController,
                :bc_controller, :defaults, :system_settings, :help_nav,
                :nav_item, :help_controller

  def initialize_sound
    category_err = Pointer.new(:id)
    session_err = Pointer.new(:id)
    @session = AVAudioSession.sharedInstance
    success = @session.setActive(true, error: session_err)
    if success
      success = @session.setCategory(AVAudioSessionCategoryPlayback, 
        # withOptions: AVAudioSessionCategoryOptionMixWithOthers,
        error: category_err)
      puts "*** Failed to set audio category!" # unless success
    else
      puts "*** Failed to activate AVAudioSession!"
    end
  end

  def settingsViewControllerDidEnd(sender)
    @bc_controller.show_view(@navigationController.view, @bc_controller)
  end

  def system_settings
    @system_settings ||= NSUserDefaults.alloc.init
  end

  def is_first_run?
    if system_settings.boolForKey('first_run')
      puts "is NOT first run"
      false
    else
      system_settings.setBool(true, forKey: 'first_run')
      system_settings.synchronize
      puts "is first run"
      true
    end
  end

  def userDefaultsDidChange
    # Do nothing, this is handled in bc_controller
  end

  def application(application, didFinishLaunchingWithOptions:launchOptions)
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
  end
end
