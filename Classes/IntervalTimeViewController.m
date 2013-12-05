//
//  IntervalTimeViewController.m
//  GOLD SUMMIT
//
//  Created by osone on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IntervalTimeViewController.h"
#import "AlarmAndClockAppDelegate.h"

@interface IntervalTimeViewController ()

@end

@implementation IntervalTimeViewController
@synthesize timePicker;

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

- (void)viewWillDisappear:(BOOL)animated
{
    //	strMessage = msgTextField.text;
    //	[msgTextField resignFirstResponder];
    
    AlarmAndClockAppDelegate *delegate = (AlarmAndClockAppDelegate*)[[UIApplication sharedApplication] delegate];
    delegate.intervalHour = [timePicker hour];
    delegate.intervalMin = [timePicker minute];
    delegate.m_DisplayIntervalStatus = TRUE;

    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
