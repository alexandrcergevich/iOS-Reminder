//
//  SleepViewController.m
//  AlarmAndClock
//
//  Created by Alexandr on 11/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SleepViewController.h"
#import "SleepSelectMusicController.h"
#import "StartTimerViewController.h"
#import "EndTimeViewController.h"

@implementation SleepViewController
@synthesize tblSleepMenu, timePicker, btnStart;


// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	UIBarButtonItem *doneBt = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction:)];
	
	self.navigationItem.rightBarButtonItem = doneBt;
	self.navigationItem.title = @"Settings";
	[self.btnStart.titleLabel setTextAlignment:UITextAlignmentCenter];
}


- (void)viewWillDisappear:(BOOL)animated
{
    AlarmAndClockAppDelegate * app = [SleepAudioPlayer sharedAudioPlayer].delegate;
    app.sleepDelegate = nil;
    if (app.isSleeping)
        [self.btnStart setBackgroundImage:[UIImage imageNamed:@"red_button.png"] forState:UIControlStateNormal];
    else
        [self.btnStart setBackgroundImage:[UIImage imageNamed:@"green_button.png"] forState:UIControlStateNormal];
    [app requestSleepHour];
}

- (void)viewWillAppear:(BOOL)animated
{
    AlarmAndClockAppDelegate * app = [SleepAudioPlayer sharedAudioPlayer].delegate;
    app.sleepDelegate = self;
    
}
- (void) doneAction:(id)sender
{
	[self dismissModalViewControllerAnimated:YES];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
- (void)volumeChanged:(UISlider *)slider {
}
#pragma mark -
#pragma mark UITableViewDelegate, UITableView Data

-(void) tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
	[tblSleepMenu deselectRowAtIndexPath:indexPath animated:YES];

//G.W. 6/16/2012    
//	if (indexPath.row == 1)
//	{
//        [self.btnStart setTitle:@"Start" forState:UIControlStateNormal];
//        AlarmAndClockAppDelegate * app = [SleepAudioPlayer sharedAudioPlayer].delegate;
//        [app stopSleepHour];
//        SleepSelectMusicController *controller = [[[SleepSelectMusicController alloc] initWithStyle:UITableViewStylePlain] autorelease];
//
//        
//        [self.navigationController pushViewController:controller animated:YES];
//
//	}
    
    if (indexPath.row == 0){
        StartTimerViewController *startViewController = [[StartTimerViewController alloc] init];
        [self.navigationController pushViewController:startViewController animated:YES];
    }
    if (indexPath.row == 1){
        EndTimeViewController *endViewController = [[EndTimeViewController alloc] init];
        [self.navigationController pushViewController:endViewController animated:YES];
    }
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	int row = indexPath.row;
	
	NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d", row];
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:nil] autorelease];
		if (row == 0)
		{
            //G.W. 6/16/2012
//			MPVolumeView *volumeView = [[MPVolumeView alloc] initWithFrame:CGRectMake(0, 0, 200, 10) ];
//			cell.accessoryView = volumeView;
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}
		if (row == 1)
		{
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}
	}
	
	if (row == 0)
	{
		cell.textLabel.text = @"Start Time";
	}
	if (row == 1)
		cell.textLabel.text = @"End Time";
	
	return cell;
}

- (IBAction)startAction:(id)sender {
	int hour, minute;
	hour = [timePicker hour];
	minute = [timePicker minute];
    [self.btnStart setHighlighted:NO];
    AlarmAndClockAppDelegate * app = [SleepAudioPlayer sharedAudioPlayer].delegate;

    if (app.isSleeping == YES)
	{
        [self.btnStart setTitle:@"Start" forState:UIControlStateNormal];
        AlarmAndClockAppDelegate * app = [SleepAudioPlayer sharedAudioPlayer].delegate;
        [app stopSleepHour];
        
        [self.btnStart setBackgroundImage:[UIImage imageNamed:@"green_button.png"] forState:UIControlStateNormal];
	}
	else {
        if (hour == 0 && minute == 0)
            return;
        [self.btnStart setTitle:[NSString stringWithFormat:@"Stop (%02d:%02d:00)", hour, minute] forState:UIControlStateNormal];
                [app startSleepForHour:hour andForMinute:minute];
        [self.btnStart setBackgroundImage:[UIImage imageNamed:@"red_button.png"] forState:UIControlStateNormal];
    }
}

- (void)timeChangedtoHour:(int)toHour andMinute:(int)toMinute andSecond:(int)toSecond {
	int hour = toHour;
	int minute = toMinute;
	int second = toSecond;
	if (hour == 0 && minute == 0 && second == 0)
	{
        [self.btnStart setTitle:@"Start" forState:UIControlStateNormal];	
    }
	else {
        [self.btnStart setTitle:[NSString stringWithFormat:@"Stop (%02d:%02d:%02d)", hour, minute, second] forState:UIControlStateNormal];
        
	}

	
}

#pragma mark -
#pragma mark MPMediaPickerController


- (void) mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
	[mediaPicker dismissModalViewControllerAnimated:YES];
}
#pragma mark -
#pragma mark Freeling memory
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[tblSleepMenu release];
	[timePicker release];
	[btnStart release];
	[super dealloc];
}


@end
