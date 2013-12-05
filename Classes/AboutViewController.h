//
//  AboutViewController.h
//  AlarmAndClock
//
//  Created by Alexandr on 1/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
@interface AboutViewController : UIViewController <MFMailComposeViewControllerDelegate>
- (IBAction)giftButtonPressed:(id)sender;
- (IBAction)visitButtonPressed:(id)sender;
- (IBAction)emailButtonPressed:(id)sender;
- (IBAction)facebookButtonPressed:(id)sender;
- (IBAction)twitterButtonPressed:(id)sender;
- (IBAction)bannerButtonPressed:(id)sender;
@end
