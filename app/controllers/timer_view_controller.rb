 class TimerViewController < UIViewController
  extend IB
  include SoundHelper

  outlet :in_out_button, UIButton
  outlet :timer, UILabel
  outlet :reset, UIButton
  outlet :time_to_run, UITextView
  outlet :target_bpm_disp, UILabel
  outlet :actual_bpm_disp, UILabel

  ib_action :tap_in_out_button
  ib_action :tap_reset

  attr_accessor :target_bpm, :settings, :in_sound, :out_sound,
                :rain_sound, :binaural_sound, :time_to_run,
                :act_in_avg, :act_out_avg

  def viewDidLoad
    super
    puts "rain_sound = #{@rain_sound}"
    puts "binaural_sound = #{@binaural_sound}"
    puts "in_sound = #{@in_sound}"
    puts "out_sound = #{@out_sound}"
    reset
    @delegate = UIApplication.sharedApplication.delegate
    @sb = @delegate.sb
    @window = UIApplication.sharedApplication.keyWindow
    @target_bpm_disp.text = "%0.2f" % target_bpm.to_f
    @actual_bpm_disp.text = "%0.2f" % bpm

    @static_algorithm = lambda do
      if @act_in_avg + @act_out_avg > @target_bpm
        @act_in_avg -= 0.5
        @act_out_avg -= 0.5
      end
    end
    @golden_ratio_algorithm = lambda do
      # Golden ratio is 1:1.6.  We want the longer period to be the out breath.
      # Even if the overall BPM is approximately at target, we want to shift
      # in and out breaths to reach the golden ratio.
      puts "entering decayer: @act_in_avg = #{@act_in_avg}, @act_out_avg = #{@act_out_avg}"
      out_factor = 1
      in_factor = 1
      @breathing_ratio = @act_out_avg / @act_in_avg
      if bpm_is_high
        if ratio_too_high # out breath needs to reduce rel to in
          @act_out_avg *= 0.95
        elsif ratio_too_low
          @act_in_avg *= 0.95
        end
      elsif bpm_is_low
        if ratio_too_high # out breath needs to increase rel to in
          @act_out_avg *= 1.05
        elsif ratio_too_low
          @act_in_avg *= 1.05
        end
      else
        if ratio_too_high
          change_for_out = @act_out_avg * 1.05
          @act_out_avg -= change_for_out
          @act_in_avg += change_for_out
        elsif ratio_too_low
          change_for_in = @act_in_avg * 1.05
          @act_in_avg -= change_for_in
          @act_out_avg += change_for_in
        end
      end
      puts "leaving decayer: @act_in_avg = #{@act_in_avg}, @act_out_avg = #{@act_out_avg}"
    end
    @decay_algorithm = @golden_ratio_algorithm

    start_sound_if_selected(:rain)
    start_sound_if_selected(:binaural)
    start_timer
  end

  def bpm_is_high
    bpm > @target_bpm * 1.01
  end

  def bpm_is_low
    bpm < @target_bpm * 0.99
  end

  def bpm
    (60 / (@act_in_avg + @act_out_avg))
  end
  
  def ratio_too_high
    @act_out_avg.to_f / @act_in_avg > 1.66
  end

  def ratio_too_low
    @act_out_avg.to_f / @act_in_avg < 1.56
  end

  def time_since_start
    Time.now - @start_time
  end

  def remaining_time
    (@time_to_run * 60) - time_since_start
  end

  def play_ending_sound
  end

  def update_timer
    puts "begin update_timer @act_in_avg = #{@act_in_avg}, @act_out_avg = #{@act_out_avg}"
    if Time.now - @last_tick >= 1
      @last_tick = Time.now
      if remaining_time <= 0
        @timer_thread.invalidate
        play_ending_sound
      else
        mins = (remaining_time / 60).floor
        secs = remaining_time % 60
        @timer.text = "%02d:%02d" % [mins, secs]
      end
    end
    puts "end update_timer @act_in_avg = #{@act_in_avg}, @act_out_avg = #{@act_out_avg}"
  end

  def tap_reset sender
    reset
    # Now send the user back to the beat controller
    @beat_vc ||= @sb.instantiateViewControllerWithIdentifier("beat_counter")
    @beat_vc.in_sound = @in_sound
    @beat_vc.out_sound = @out_sound
    @beat_vc.rain_sound = @rain_sound
    @beat_vc.binaural_sound = @binaural_sound
    puts "about to switch back to beat controller"
    # FIXME We should also halt all our sounds here
    UIView.beginAnimations(nil, context:nil)
    UIView.setAnimationDuration(0.0)
    UIView.setAnimationTransition(UIViewAnimationTransitionFlipFromRight,
                forView:@window, cache:true)
    view.removeFromSuperview
    @window.addSubview(@beat_vc.view)
    UIView.commitAnimations
  end

  def reset
    @timer_thread.invalidate if @timer_thread
    @next_breathing_change.invalidate if @next_breathing_change
    @interval_timer.invalidate if @interval_timer
    initialize_sounds
    puts "2rain_sound = #{@rain_sound}"
    puts "2binaural_sound = #{@binaural_sound}"
    puts "2in_sound = #{@in_sound}"
    puts "2out_sound = #{@out_sound}"
    @breathing_in = true
    @next_breathing_change = nil
    @interval_timer = nil
    @decay_timer_set = false
    @decay_factor = 1.015
    @start_time = @last_tick = Time.now
    @settings = nil
    @timer_thread = nil
  end

  def start_timer
    puts "starting timer"
    @timer_thread = NSTimer.scheduledTimerWithTimeInterval(0.25,
      target:self,
      selector:'update_timer', 
      userInfo:nil, 
      repeats:true)
    change_breathing
  end

  def start_decay_timer
    @decay_timer_set = true
    @interval_timer = NSTimer.scheduledTimerWithTimeInterval(10,
      target:self,
      selector:"decay_timer",
      userInfo:nil,
      repeats:true)
  end

  def golden_ratio_algorithm
    puts "========================================================="
    puts "entering decayer: @act_in_avg = #{@act_in_avg}, @act_out_avg = #{@act_out_avg}"
    @breathing_ratio = @act_out_avg / @act_in_avg
    puts "ratio = #{@breathing_ratio}"
    puts "is ratio_too_high? #{ratio_too_high}"
    puts "is ratio_too_low? #{ratio_too_low}"
    puts "bpm_is_high = #{bpm_is_high}"
    puts "bpm_is_low = #{bpm_is_low}"
    if bpm_is_high
      # IMPORTANT.  If BPM is high, we need to INCREASE length of 
      # act in and act out, not decrease
      if ratio_too_high # out breath needs to reduce rel to in
        @act_in_avg *= 1.05
      elsif ratio_too_low
        @act_out_avg *= 1.05
      else
        # decrease overall bpm
        @act_out_avg *= 1.05
        @act_in_avg *= 1.05
      end
    elsif bpm_is_low
      if ratio_too_high # out breath needs to increase rel to in
        @act_in_avg *= 0.95
      elsif ratio_too_low
        @act_out_avg *= 0.95
      else
        # increase overall bpm
        @act_out_avg *= 0.95
        @act_in_avg *= 0.95
      end
    else
      if ratio_too_high
        change_for_out = @act_out_avg * 0.05
        puts "change_for_out = #{change_for_out}"
        @act_out_avg -= change_for_out
        @act_in_avg += change_for_out
      elsif ratio_too_low
        change_for_in = @act_in_avg * 0.05
        puts "change_for_in = #{change_for_in}"
        @act_in_avg -= change_for_in
        @act_out_avg += change_for_in
      end
    end
    while bpm < @target_bpm
      @act_out_avg *= 0.999
      @act_in_avg *= 0.999
    end
    puts "leaving decayer: @act_in_avg = #{@act_in_avg}, @act_out_avg = #{@act_out_avg}"
    [@act_in_avg, @act_out_avg]
  end

  def decay_timer
    @act_in_avg, @act_out_avg = golden_ratio_algorithm #@decay_algorithm.call
    @actual_bpm_disp.text = "%.2f" % bpm
  end

  def next_breathing_timer(at_time)
    @next_breathing_change = NSTimer.scheduledTimerWithTimeInterval(at_time,
      target:self,
      selector:"change_breathing",
      userInfo:nil,
      repeats:false)
  end

  def perform_breathe_in_actions
    puts "begin perform_breathe_in_actions @act_in_avg = #{@act_in_avg}"
    @breathing_in = !@breathing_in
    start_sound_if_selected :in
    @in_out_button.setTitle("Breathe In", forState:UIControlStateNormal)
    puts "perform_breathe_in_actions @act_in_avg = #{@act_in_avg}"
    next_breathing_timer(@act_in_avg)
  end

  def perform_breathe_out_actions
    @breathing_in = !@breathing_in
    start_sound_if_selected :out
    @in_out_button.setTitle("Breathe Out", forState:UIControlStateNormal)
    puts "perform_breathe_out_actions @act_out_avg = #{@act_out_avg}"
    next_breathing_timer(@act_out_avg)
  end

  def change_breathing
    if @breathing_in
      perform_breathe_in_actions
    else
      perform_breathe_out_actions
    end
    start_decay_timer if !@decay_timer_set
  end

  def start_sound_if_selected(sound_name)
    if true # if settings have positive boolean value for symbol, then play
      case sound_name
      when :rain
        puts "3rain_sound = #{@rain_sound}, volume = #{@rain_sound.volume}"
        @rain_sound.volume = @delegate.bc_controller.ambient_volume
        @rain_sound.play
      when :binaural
        puts "3binaural_sound = #{@binaural_sound}"
        @binaural_sound.volume = @delegate.bc_controller.binaural_volume
        @binaural_sound.play
      when :in
        puts "3in_sound = #{@in_sound}"
        @in_sound.play
      when :out
        puts "3out_sound = #{@out_sound}"
        @out_sound.play
      end
    end
  end
end