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

  def initialize_sounds
    @rain_sound = get_sound(@rain_sound, name: "rain.mp3", repeat: :forever, delegate: self)
    @binaural_sound = get_sound(@binaural_sound, name: "gnaural.m4a", repeat: :once, delegate: self)
    @in_sound = get_sound(@in_sound, name: "breathe_in_long.m4a", repeat: :once, delegate: self)
    @out_sound = get_sound(@out_sound, name: "breathe_out_long.m4a", repeat: :once, delegate: self)
  end
end