// Generated by IB v0.2.10 gem. Do not edit it manually
// Run `rake ib:open` to refresh

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

@interface ParserError: StandardError







@end


@interface NSNotificationCenter





-(IBAction) observers;
-(IBAction) unobserve:(id) observer;

@end


@interface NSURLRequest





-(IBAction) to_s;

@end


@interface Camera





-(IBAction) initialize:(id) location;
-(IBAction) location;
-(IBAction) imagePickerControllerDidCancel:(id) picker;
-(IBAction) picker;
-(IBAction) dismiss;
-(IBAction) camera_device;
-(IBAction) media_type_to_symbol:(id) media_type;
-(IBAction) symbol_to_media_type:(id) symbol;
-(IBAction) error:(id) type;

@end


@interface UIView





-(IBAction) handle_gesture:(id) recognizer;

@end


@interface UIAlertView





-(IBAction) style;
-(IBAction) cancel_button_index;

@end


@interface ClickedButton





-(IBAction) willPresentAlertView:(id) alert;
-(IBAction) didPresentAlertView:(id) alert;
-(IBAction) alertViewCancel:(id) alert;
-(IBAction) alertViewShouldEnableFirstOtherButton:(id) alert;
-(IBAction) plain_text_field;
-(IBAction) secure_text_field;
-(IBAction) login_text_field;
-(IBAction) password_text_field;

@end


@interface UIViewController





-(IBAction) content_frame;

@end


@interface InvalidURLError: StandardError







@end


@interface InvalidFileError: StandardError







@end


@interface BubbleWrap





-(IBAction) to_s;
-(IBAction) connectionDidFinishLoading:(id) connection;
-(IBAction) show_status_indicator:(id) show;
-(IBAction) create_request;
-(IBAction) set_content_type;
-(IBAction) create_request_body;
-(IBAction) append_payload:(id) body;
-(IBAction) append_form_params:(id) body;
-(IBAction) append_auth_header;
-(IBAction) append_files:(id) body;
-(IBAction) append_body_boundary:(id) body;
-(IBAction) create_url:(id) url_string;
-(IBAction) validate_url:(id) url;
-(IBAction) escape:(id) string;
-(IBAction) convert_payload_to_url;
-(IBAction) log:(id) message;
-(IBAction) escape_line_feeds:(id) hash;
-(IBAction) patch_nsurl_request:(id) request;
-(IBAction) call_delegator_with_response;

@end


@interface BubbleWrap





-(IBAction) initialize:(id) values;
-(IBAction) update:(id) values;
-(IBAction) to_s;
-(IBAction) update_status_description;

@end


@interface AppDelegate

@property IBOutlet UIWindow * window;



-(IBAction) initialize_sound;
-(IBAction) settingsViewControllerDidEnd:(id) sender;
-(IBAction) system_settings;
-(IBAction) userDefaultsDidChange;

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
-(IBAction) tap_settings:(id) sender;
-(IBAction) tap_help:(id) sender;
-(IBAction) initialize_state;
-(IBAction) viewDidLoad;
-(IBAction) textFieldDidEndEditing:(id) field;
-(IBAction) doneWithNumberPad;
-(IBAction) applicationWillTerminate:(id) notification;
-(IBAction) supportedInterfaceOrientations;
-(IBAction) still_collecting_initial_data;
-(IBAction) was_breathing_in;
-(IBAction) bpm;
-(IBAction) toggle_breathing_state;
-(IBAction) update_status_text;
-(IBAction) start_timer;

@end


@interface HelpViewController: UIViewController

@property IBOutlet UITextView * help_text;



-(IBAction) viewDidLoad;
-(IBAction) doneWithHelp:(id) sender;

@end


@interface TimerViewController: UIViewController

@property IBOutlet UIButton * in_out_button;
@property IBOutlet UILabel * timer;
@property IBOutlet UIButton * reset;
@property IBOutlet UITextView * time_to_run;
@property IBOutlet UILabel * target_bpm_disp;
@property IBOutlet UILabel * actual_bpm_disp;
@property IBOutlet AVAudioPlayer * ambient_sound;
@property IBOutlet AVAudioPlayer * binaural_sound;
@property IBOutlet AVAudioPlayer * in_sound;
@property IBOutlet AVAudioPlayer * out_sound;



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



