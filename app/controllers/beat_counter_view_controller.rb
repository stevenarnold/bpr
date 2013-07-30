class BeatCounterViewController < UIViewController
  extend IB
  include SoundHelper

  outlet :in_out_button, UIButton
  outlet :progress_display, UILabel
  outlet :reset, UIButton
  outlet :target, UITextField
  outlet :time_to_run, UITextField
  outlet :timer, UILabel

  ib_action :tap_in_out_button
  ib_action :tap_reset

  attr_accessor :in_sound, :out_sound, :rain_sound, :binaural_sound

  def load_settings
    # NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    # NSString *documentsDirectory = [paths objectAtIndex:0];
    # settingsFilename = [documentsDirectory stringByAppendingPathComponent:@"settings.plist"];
    # if (![[NSFileManager defaultManager] fileExistsAtPath:settingsFilename]) {
    #     NSLog(@"No settings file name found, using default");
    #     settingsFilename = SETTINGS;
    # }
    # NSLog(@"settings file is supposed to be at path = %@", settingsFilename);
    # if ([[NSFileManager defaultManager] fileExistsAtPath:settingsFilename]) {
    #     NSLog(@"Settings file '%@' exists, loading it", settingsFilename);
    #     settings = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsFilename];
    #     target.value = [[settings valueForKey:@"bpm"] floatValue];
    #     NSLog(@"[settings valueForKey:@bpm] = %@", [settings valueForKey:@"bpm"]);
    #     targetValue.text = [[settings valueForKey:@"bpm"] stringValue];
    #     NSLog(@"1");
    #     timeToRun.value = [[settings valueForKey:@"time"] floatValue];
    #     NSLog(@"2");
    #     NSLog(@"timeToRun.value = %2.2f", timeToRun.value);
    #     timeToRunValue.text = [NSString stringWithFormat:@"%2.2f", timeToRun.value];
    #     NSLog(@"3");
    # } else {
    #     NSLog(@"Settings file does NOT exist, initializing");
    #     settings = [[NSMutableDictionary alloc] init];
    #     target.value = kDefaultTarget;
    #     targetValue.text = kDefaultTargetBPM;
    #     timeToRun.value = kDefaultTime;
    #     timeToRunValue.text = kDefaultTimeStr;
    # }
  end

  def save_settings
    # [settings setValue:[NSNumber numberWithFloat:[target value]] forKey:@"bpm"];
    # [settings setValue:[NSNumber numberWithFloat:timeToRun.value] forKey:@"time"];
    # NSLog(@"settings = %@", settings);
    # NSFileManager *fileManager = [NSFileManager defaultManager];
    # NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    # NSString *documentsDirectory = [paths objectAtIndex:0];
    # NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:@"settings.plist"];
    # if (mainDelegate.deleteSettingsFile) {
    #     if ([fileManager fileExistsAtPath:fullPath])
    #         [fileManager removeItemAtPath:fullPath error:nil];
    # } else {
    #     [settings writeToFile:fullPath atomically:YES];
    # }
  end

  def initialize_state
    puts "initializing state"
    @fields_are_editing = false
    @in_count = 0
    @out_count = 0
    @act_in_avg = 0.0
    @act_out_avg = 0.0
    @measure_beats = 10
    @display_bpm = 5
    @last_beat = 0
    @breathing_state = :in
    @progress_display.text = "Press 'In' Button When Breathing In"
    @in_out_button.setTitle("Breathe In", forState:UIControlStateNormal)
    @in_out_button.setTitle("Breathe In", forState:UIControlStateHighlighted)
    puts "state initialized"
  end

  def viewDidLoad
    puts "loading beat view"
    initialize_state
    puts "state initialized"
    @delegate = UIApplication.sharedApplication.delegate
    @sb = @delegate.sb
    @window = UIApplication.sharedApplication.keyWindow
    
    # prefsVC = mainDelegate.prefsVC;
    load_settings
    initialize_sounds
    puts "beat viewDidLoad done"
    super
  end

  def applicationWillTerminate(notification)
    save_settings
  end

  def alert(title, message, btn_title="OK")
    @an_alert = UIAlertView.alloc.initWithTitle(title,
        message: message,
        delegate: nil,
        cancelButtonTitle: btn_title,
        otherButtonTitles: nil)
    @an_alert.show
  end

  def still_collecting_initial_data
    (@in_count + @out_count) < @measure_beats
  end

  def was_breathing_in
    @breathing_state == :in
  end
  alias breathing_in was_breathing_in

  def bpm
    60 / (@act_in_avg + @act_out_avg)
  end

  def toggle_breathing_state
    if was_breathing_in
      @breathing_state = :out
      btn_state_title = "Breathe Out"
    else
      @breathing_state = :in
      btn_state_title = "Breathe In"
    end
    @in_out_button.setTitle(btn_state_title, forState: UIControlStateNormal)
    @in_out_button.setTitle(btn_state_title, forState: UIControlStateHighlighted)
  end

  def update_status_text
    puts "bpm = #{bpm}, @act_in_avg = #{@act_in_avg}, @act_out_avg = #{@act_out_avg}"
    if bpm < @display_bpm
      @progress_display.text = "Collecting Data... #{@in_count + @out_count} of #{@measure_beats}"
    else
      @progress_display.text = "Collecting Data... #{@in_count + @out_count} of #{@measure_beats}; BPM = %2.2f" % bpm
    end
  end

  def start_timer
    @timer_started_at = Time.now
    @timer_vc ||= @sb.instantiateViewControllerWithIdentifier("timer")
    @timer_vc.target_bpm = @target.text.to_f
    @timer_vc.time_to_run = @time_to_run.text.to_f
    @timer_vc.act_in_avg = @act_in_avg
    @timer_vc.act_out_avg = @act_out_avg
    @timer_vc.in_sound = @in_sound
    @timer_vc.out_sound = @out_sound
    @timer_vc.rain_sound = @rain_sound
    @timer_vc.binaural_sound = @binaural_sound
    # FIXME We should also halt all our sounds here
    UIView.beginAnimations(nil, context:nil)
    UIView.setAnimationDuration(0.0)
    UIView.setAnimationTransition(UIViewAnimationTransitionFlipFromRight,
                forView:@window, cache:true)
    view.removeFromSuperview
    @window.addSubview(@timer_vc.view)
    UIView.commitAnimations
  end

  # Actions
  def tap_in_out_button sender
    puts "entering tap_in_out_button"
    puts "@act_out_avg = #{@act_out_avg}"
    puts "@act_in_avg = #{@act_in_avg}"
    update_status_text
    if still_collecting_initial_data
      puts "yep, still collecting initial data"
      interval = Time.now - @last_beat
      interval = 5 if interval.class == Time
      @last_beat = Time.now
      puts "@act_in_avg = #{@act_in_avg}, @act_out_avg = #{@act_out_avg}, @in_count = #{@in_count}, interval = #{interval}"
      if was_breathing_in
        @out_count += 1
        @act_out_avg = ((@act_out_avg * (@out_count - 1)) + interval) / @out_count
        @out_sound.play
      else
        @in_count += 1
        @act_in_avg = ((@act_in_avg * (@in_count - 1)) + interval) / @in_count
        @in_sound.play
      end
      toggle_breathing_state
    else
      puts "preparing to start timer"
      start_timer
    end
    puts "exiting tap_in_out_button"
  end

  def tap_reset sender
    puts "woo hoo!"
    initialize_state
  end
end



