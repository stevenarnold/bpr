module SoundHelper
  # Sound management

  attr_accessor :tone_volume, :binaural_volume, :ambient_volume, :ambient_program,
                :defaults

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

  def valid_program?(program)
    %w[rain.mp3 ocean.m4a forest.m4a].include?(program)
  end

  def initialize_defaults(delegate=nil)
    @delegate = delegate if delegate
    puts "id 01"
    @defaults = @delegate.defaults if !@defaults
    puts "id 02: @defaults = #{@defaults}"
    @tone_volume = @defaults.floatForKey('toneVolume') * (1.0 / 100.0)
    puts "tone_volume = #{@tone_volume}"
    @binaural_volume = @defaults.floatForKey('binauralVolume') * (1.0 / 100.0)
    puts "binaural_volume = #{@binaural_volume}"
    @ambient_volume = @defaults.floatForKey('ambientVolume') * (1.0 / 100.0)
    puts "ambient_volume = #{@ambient_volume}"
    @ambient_program = @defaults.objectForKey('ambientProgram')
    puts "ambient_program = #{@ambient_program}"
    @ambient_program = "rain.mp3" unless valid_program?(@ambient_program)
    puts "ambient_program = #{@ambient_program}"
  end

  def reset_sound(sound, filename, repeat=:forever)
    get_sound(sound, name: filename, repeat: repeat, delegate: self)
  end

  def initialize_sounds
    puts "is 01"
    initialize_defaults if !@defaults
    puts "is 02"
    @ambient_sound = get_sound(@ambient_sound, name: @ambient_program, repeat: :forever, delegate: self)
    puts "is 03"
    @binaural_sound = get_sound(@binaural_sound, name: "gnaural.m4a", repeat: :once, delegate: self)
    puts "is 04"
    @in_sound = get_sound(@in_sound, name: "breathe_in_long.m4a", repeat: :once, delegate: self)
    puts "is 05"
    @out_sound = get_sound(@out_sound, name: "breathe_out_long.m4a", repeat: :once, delegate: self)
    puts "is 06"
  end
end