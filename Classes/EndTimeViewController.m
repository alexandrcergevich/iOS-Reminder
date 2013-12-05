//
//  EndTimeViewController.m
//  GOLD SUMMIT
//
//  Created by osone on 6/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EndTimeViewController.h"
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

@interface EndTimeViewController ()

@end

@implementation EndTimeViewController
@synthesize endtimePicker;

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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
    NSDate* now = [self dateToGMT:self.endtimePicker.date];
    NSString* dateString = [now description];
    NSArray* arr1 = [dateString componentsSeparatedByString:@" "];
    NSString* time = (NSString*)[arr1 objectAtIndex:1];
    NSArray* arr2 = [time componentsSeparatedByString:@":"];
    NSString* sHour = (NSString*)[arr2 objectAtIndex:0];
    NSString* sMinute = (NSString*)[arr2 objectAtIndex:1];
    
    AlarmAndClockAppDelegate *delegate = (AlarmAndClockAppDelegate*)[[UIApplication sharedApplication] delegate];
    delegate.endTime = endtimePicker.date;
    delegate.endHour = [sHour intValue];
    delegate.endMinute = [sMinute intValue];
    delegate.m_DisplayEndTimeStatus = TRUE;
}

@end
