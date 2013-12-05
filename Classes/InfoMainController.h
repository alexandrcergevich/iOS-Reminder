//
//  InfoMainController.h
//  AlarmAndClock
//
//  Created by Alexandr on 1/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    STATE_HELP,
    STATE_ABOUT
} ViewState;
@class AboutViewController;
@class HelpViewController;
@class ClockViewController;
@interface InfoMainController : UIViewController
{
    ViewState state;
}
@property (nonatomic, assign) ClockViewController *delegate;
@property (nonatomic, retain) AboutViewController *vcAbout;
@property (nonatomic, retain) HelpViewController *vcHelp;
@property (nonatomic, retain) IBOutlet UIView *vwContainer;
@property (nonatomic, retain) IBOutlet UIButton *btnAbout;
@property (nonatomic, retain) IBOutlet UIButton *btnHelp;
- (IBAction)backButtonPressed:(id)sender;
- (IBAction)aboutButtonPressed:(id)sender;
- (IBAction)helpButtonPressed:(id)sender;
@end
