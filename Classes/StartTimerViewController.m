//
//  StartTimerViewController.m
//  GOLD SUMMIT
//
//  Created by osone on 6/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StartTimerViewController.h"

#import "AlarmViewController.h"
#import "RepeatAlarmViewController.h"
#import "SoundMusicViewController.h"
#import "AlarmAndClockAppDelegate.h"
#import "Database.h"
#import "Global.h"
#import "SnoozeSettingController.h"
#import "StartTimerViewController.h"
#import "EndTimeViewController.h"
#import "IntervalTimeViewController.h"


@interface StartTimerViewController ()

@end

@implementation StartTimerViewController
@synthesize starttimePicker;
@synthesize nSelectAlarm;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"Start Time";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (NSDate*) dateToGMT:(NSDate*)sourceDate
{
	
	NSTimeZone* destTimeZone = [NSTimeZone localTimeZone];
	NSInteger destGMTOffset = [destTimeZone secondsFromGMTForDate:sourceDate];
	NSDate* destDate = [[[NSDate alloc] initWithTimeInterval:destGMTOffset sinceDate:sourceDate] autorelease];
	return destDate;
    
	return sourceDate;
}



- (void)viewWillDisappear:(BOOL)animated
{
//	strMessage = msgTextField.text;
//	[msgTextField resignFirstResponder];
    NSDate* now = [self dateToGMT:self.starttimePicker.date];
    NSString* dateString = [now description];
    NSArray* arr1 = [dateString componentsSeparatedByString:@" "];
    NSString* time = (NSString*)[arr1 objectAtIndex:1];
    NSArray* arr2 = [time componentsSeparatedByString:@":"];
    NSString* sHour = (NSString*)[arr2 objectAtIndex:0];
    NSString* sMinute = (NSString*)[arr2 objectAtIndex:1];
//    NSLog(@"sHour -> %2d : sMinute -> %2d", sHour, sMinute);
    
    AlarmAndClockAppDelegate *delegate = (AlarmAndClockAppDelegate*)[[UIApplication sharedApplication] delegate];
    delegate.startTime = starttimePicker.date;
    NSLog(@"sHour%@", [delegate.startTime description]);
    delegate.startHour = [sHour intValue];
    delegate.startMinute = [sMinute intValue];
    delegate.m_DisplayStartTimeStatus = TRUE;

}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
