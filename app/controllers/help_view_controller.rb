class HelpViewController < UIViewController
  extend IB

  outlet :help_text, UITextView

  attr_accessor :beat_vc

  def viewDidLoad
    super
    puts "loading help view"
    @delegate = UIApplication.sharedApplication.delegate
    @window = UIApplication.sharedApplication.keyWindow
    puts "finished loading help view"
  end

  def done_with_help
    UIView.beginAnimations(nil, context:nil)
    UIView.setAnimationDuration(0.0)
    UIView.setAnimationTransition(UIViewAnimationTransitionFlipFromRight,
                forView:@window, cache:true)
    view.removeFromSuperview
    @window.addSubview(@beat_vc.view)
    UIView.commitAnimations
  end
end