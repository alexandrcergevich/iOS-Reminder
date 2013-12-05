//
//  SleepViewController.h
//  AlarmAndClock
//
//  Created by Alexandr on 11/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "SleepAudioPlayer.h"
#import "AlarmAndClockAppDelegate.h"
@interface SleepViewController : UIViewController 
<UITableViewDelegate, UITableViewDataSource, SleepAudioPlayerDelegate>{
}

@property (nonatomic, retain) IBOutlet UITableView *tblSleepMenu;
@property (nonatomic, retain) IBOutlet UIDatePicker *timePicker;

//G.W. 6/16/2012
@property (nonatomic, retain) IBOutlet UIButton *btnStart;

- (IBAction)startAction:(id)sender;
@end
