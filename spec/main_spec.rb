def pending
  true.should == true
end

describe "Application 'rm-bpr'" do
  before do
    @app = UIApplication.sharedApplication
  end

  it "has one window" do
    @app.windows.size.should == 1
  end

  it "should set rootviewcontroller as BeatCounterViewController" do
    @app.keyWindow.rootViewController.class.should == BeatCounterViewController
  end
end

describe "BeatCounterViewController" do
  before do
    @app = UIApplication.sharedApplication
  end

  it "should have a timer" do
    pending
  end

  it "should have a target BPM textbox" do
    pending
  end

  it "should have a time to run textbox" do
    pending
  end

  it "should have a reset button" do
    pending
  end

  it "should have an in/out breathing button" do
    pending
  end
end

describe "Golden Ratio algorithm" do
  before do
    @app = UIApplication.sharedApplication
    @app_delegate = AppDelegate.new
    @app_delegate.defaults = NSUserDefaults.standardUserDefaults
    @timer_vc = TimerViewController.new
    @timer_vc.delegate = @app_delegate
    @timer_vc.target_bpm = 6.5
    @timer_vc.time_to_run = 10
    @timer_vc.act_in_avg = 17
    @timer_vc.act_out_avg = 17
    @timer_vc.initialize_sounds
  end

  it "should change the ratio more toward the Golden Ratio" do
    pending
  end

  it "should reduce @act_out_avg and increase @act_in_avg" do
    pending
  end

  it "should eventually approximate the Golden Ratio" do
    pending
  end
end
