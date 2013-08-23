module SoundHelper
  # Sound management

  attr_accessor :tone_volume, :binaural_volume, :ambient_volume

  def play(sound)
    puts "sound = #{sound}"
    if sound.isPlaying
      sound.stop
      sound.currentTime = 0
    end
    sound.play
  end

  def stop(sound)
    if sound.isPlaying
      sound.stop
      sound.currentTime = 0
    end
  end

  def play_in_sound
    in_sound.volume = @tone_volume
    play(in_sound)
  end

  def play_out_sound
    out_sound.volume = @tone_volume
    play(out_sound)
  end

  def get_sound(sound, name: name, repeat: repeat, delegate: delegate)
    # Note: On the simulator, this might fail for some sound inputs on the host system.
    # The built-in mic worked for me.  The system sound input has nothing to do with 
    # this function or app, but setting it wrong seems to break the simulator.
    if sound && sound.isPlaying
      stop(sound)
      return sound
    end
    name, ext = name.split('.')
    res_path = NSBundle.mainBundle.pathForResource(name, ofType:ext)

    err = Pointer.new('@', 2)
    sound = AVAudioPlayer.alloc.initWithContentsOfURL(NSURL.fileURLWithPath(res_path), error:err)
    sound.delegate = delegate
    sound.numberOfLoops = case repeat
      when :forever
        -1
      when :once
        0
    end
    sound.prepareToPlay
    sound
  end

  def initialize_defaults(controller=self, defaults=nil)
    defaults = @delegate.defaults if !defaults
    controller.tone_volume = defaults.floatForKey('toneVolume') * (1.0 / 100.0)
    puts "tone_volume = #{controller.tone_volume}"
    controller.binaural_volume = defaults.floatForKey('binauralVolume') * (1.0 / 100.0)
    puts "binaural_volume = #{controller.binaural_volume}"
    controller.ambient_volume = defaults.floatForKey('ambientVolume') * (1.0 / 100.0)
    puts "ambient_volume = #{controller.ambient_volume}"
    controller.ambient_program = defaults.objectForKey('ambientProgram')
    puts "ambient_program = #{controller.ambient_program}"
  end

  def reset_sound(sound, filename, repeat=:forever)
    get_sound(sound, name: filename, repeat: repeat, delegate: self)
  end

  def initialize_sounds
    @ambient_sound = get_sound(@ambient_sound, name: "rain.mp3", repeat: :forever, delegate: self)
    @binaural_sound = get_sound(@binaural_sound, name: "gnaural.m4a", repeat: :once, delegate: self)
    @in_sound = get_sound(@in_sound, name: "breathe_in_long.m4a", repeat: :once, delegate: self)
    @out_sound = get_sound(@out_sound, name: "breathe_out_long.m4a", repeat: :once, delegate: self)
  end
end