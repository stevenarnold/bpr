// Generated by IB v0.2.10 gem. Do not edit it manually
// Run `rake ib:open` to refresh

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

@interface AppDelegate

@property IBOutlet UIWindow * window;



-(IBAction) initialize_sound;

@end


@interface BeatCounterViewController: UIViewController

@property IBOutlet UIButton * in_out_button;
@property IBOutlet UILabel * progress_display;
@property IBOutlet UIButton * reset;
@property IBOutlet UITextField * target;
@property IBOutlet UITextField * time_to_run;
@property IBOutlet UILabel * timer;



-(IBAction) tap_in_out_button:(id) sender;
-(IBAction) tap_reset:(id) sender;
-(IBAction) load_settings;
-(IBAction) save_settings;
-(IBAction) initialize_state;
-(IBAction) viewDidLoad;
-(IBAction) applicationWillTerminate:(id) notification;
-(IBAction) still_collecting_initial_data;
-(IBAction) was_breathing_in;
-(IBAction) bpm;
-(IBAction) toggle_breathing_state;
-(IBAction) update_status_text;
-(IBAction) start_timer;

@end


@interface TimerViewController: UIViewController

@property IBOutlet UIButton * in_out_button;
@property IBOutlet UILabel * timer;
@property IBOutlet UIButton * reset;
@property IBOutlet UITextView * time_to_run;
@property IBOutlet UILabel * target_bpm_disp;
@property IBOutlet UILabel * actual_bpm_disp;



-(IBAction) tap_in_out_button:(id) sender;
-(IBAction) tap_reset:(id) sender;
-(IBAction) viewDidLoad;
-(IBAction) bpm_is_high;
-(IBAction) bpm_is_low;
-(IBAction) bpm;
-(IBAction) ratio_too_high;
-(IBAction) ratio_too_low;
-(IBAction) time_since_start;
-(IBAction) remaining_time;
-(IBAction) play_ending_sound;
-(IBAction) update_timer;
-(IBAction) reset;
-(IBAction) start_timer;
-(IBAction) start_decay_timer;
-(IBAction) golden_ratio_algorithm;
-(IBAction) decay_timer;
-(IBAction) next_breathing_timer:(id) at_time;
-(IBAction) perform_breathe_in_actions;
-(IBAction) perform_breathe_out_actions;
-(IBAction) change_breathing;
-(IBAction) start_sound_if_selected:(id) sound_name;

@end



