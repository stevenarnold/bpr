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
    @in_sound.volume = @tone_volume
    play(@in_sound)
  end

  def play_out_sound
    @out_sound.volume = @tone_volume
    play(@out_sound)
  end

  def play_ending_sound
    @ending_sound.volume = @ending_sound_volume
    play(@ending_sound)
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
    puts "id 01"
    @defaults = @delegate.defaults if !@defaults
    puts "id 02: @defaults = #{@defaults}"
    @tone_volume = @defaults.floatForKey('toneVolume') * (1.0 / 100.0)
    puts "id 03"
    @binaural_volume = @defaults.floatForKey('binauralVolume') * (1.0 / 100.0)
    puts "id 04"
    @ambient_volume = @defaults.floatForKey('ambientVolume') * (1.0 / 100.0)
    @ending_sound_volume = @defaults.floatForKey('endingSoundVolume') * (1.0 / 100.0)
    puts "id 05"
    @ambient_program = @defaults.objectForKey('ambientProgram')
    puts "id 06"
    if @delegate.is_first_run?
      puts "id 07"
      @tone_volume = @binaural_volume = @ambient_volume = @ending_sound_volume = 0.50
      puts "id 09"
      @defaults.setFloat(50.0, forKey: 'binauralVolume')
      puts "id 10"
      @defaults.setFloat(50.0, forKey: 'ambientVolume')
      puts "id 11"
      @defaults.setFloat(50.0, forKey: 'toneVolume')
      @defaults.setFloat(50.0, forKey: 'endingSoundVolume')
    end
    puts "id 13"
    @ambient_program = "rain.mp3" unless valid_program?(@ambient_program)
    puts "id 14"
    puts "tone_volume = #{@tone_volume}"
    puts "binaural_volume = #{@binaural_volume}"
    puts "ambient_volume = #{@ambient_volume}"
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
    @ambient_sound.volume = @ambient_volume
    puts "is 03"
    @binaural_sound = get_sound(@binaural_sound, name: "gnaural.m4a", repeat: :once, delegate: self)
    @binaural_sound.volume = @binaural_volume
    puts "is 04"
    @in_sound = get_sound(@in_sound, name: "breathe_in_long.m4a", repeat: :once, delegate: self)
    @in_sound.volume = @tone_volume
    puts "is 05"
    @out_sound = get_sound(@out_sound, name: "breathe_out_long.m4a", repeat: :once, delegate: self)
    @out_sound.volume = @tone_volume
    puts "is 06"
    if !@program_ending
      puts "is 07"
      @ending_sound = get_sound(@ending_sound, name: "gongs_ending.m4a", repeat: :once, delegate: nil)
      @ending_sound.volume = @ending_sound_volume
    end
  end
end