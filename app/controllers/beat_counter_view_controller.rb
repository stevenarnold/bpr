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
  ib_action :tap_settings

  attr_accessor :in_sound, :out_sound, :ambient_sound, :binaural_sound, :timer,
                :tone_volume, :ambient_volume, :binaural_volume, :ambient_program,
                :delegate

  def load_settings
    initialize_defaults
  end

  def initialize_state
    puts "initializing state"
    initialize_defaults
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
    load_settings
    puts "state initialized"
  end

  def viewDidLoad
    super
    @delegate = UIApplication.sharedApplication.delegate
    NSNotificationCenter.defaultCenter.addObserver(self,
      selector:"initialize_defaults:",
      name:NSUserDefaultsDidChangeNotification,
      object:nil)
    puts "delegate = #{@delegate}"
    initialize_state
    puts "state initialized"
    @sb = @delegate.sb
    puts "@delegate.sb = #{@delegate.sb}"
    @settings = @delegate.settings
    @settings.delegate = @delegate
    @settings.showDoneButton = true
    @navigationController = @delegate.navigationController
    @window = UIApplication.sharedApplication.keyWindow
    puts "vdl 05"
    
    initialize_sounds
    puts "beat viewDidLoad done"
  end

  def applicationWillTerminate(notification)
    save_settings
  end

  def supportedInterfaceOrientations
    UIInterfaceOrientationMaskPortrait
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
    @in_sound.volume = @tone_volume
    @out_sound.volume = @tone_volume
    @ambient_sound.volume = @ambient_volume
    puts "*** When setting, @ambient_volume = #{@ambient_volume}"
    @binaural_sound.volume = @binaural_volume
    @timer_vc.in_sound = @in_sound
    @timer_vc.out_sound = @out_sound
    @timer_vc.ambient_sound = @ambient_sound
    @timer_vc.binaural_sound = @binaural_sound
    UIView.beginAnimations(nil, context:nil)
    UIView.setAnimationDuration(0.0)
    UIView.setAnimationTransition(UIViewAnimationTransitionFlipFromRight,
                forView:@window, cache:true)
    show_view(view, @timer_vc)
    UIView.commitAnimations
    @timer_vc.viewDidLoad
  end

  def show_view(old_view, new_vc)
    old_view.removeFromSuperview
    @window.addSubview(new_vc.view)
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
        @out_sound.volume = @tone_volume
        @out_sound.play
      else
        @in_count += 1
        @act_in_avg = ((@act_in_avg * (@in_count - 1)) + interval) / @in_count
        @in_sound.volume = @tone_volume
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
    initialize_state
  end

  def tap_settings sender
    puts "settings 01: @settings = #{@settings}"
    @view = view
    show_view(view, @navigationController)
    # @navigationController.pushViewController(@settings, animated:true)
    puts "settings 05"
  end
end



