//
//  SoundMusicViewController.m
//  AlarmAndClock
//
//  Created by Alexandr on 11/2/11.
//  Copyright 2011 12345. All rights reserved.
//

#import "SoundMusicViewController.h"
#import "Database.h"
#import "AlarmAndClockAppDelegate.h"

@implementation SoundMusicViewController

@synthesize tlbView;
@synthesize doneBt;
@synthesize soundVolume;
@synthesize nSelectAlarm;
@synthesize sectionsArray;
@synthesize audioPlayer;
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
//	doneBt = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
	
//	self.navigationItem.rightBarButtonItem = doneBt;
	self.navigationItem.title = @"Sound & Music";
	
	NSMutableArray* array1 = [[NSMutableArray alloc] initWithCapacity:7];
	[array1 addObject:@"Volume"];
	
	
	sectionsArray = [[NSMutableArray alloc] initWithCapacity:2];
	[sectionsArray addObject:array1];
	[sectionsArray addObject:alarmSoundArray];
	
	[array1 release];
    /*
     self.audioPlayer = nil;
     for (int index = 0; index < 2; index++) {
     NSMutableArray *array = [[NSMutableArray alloc] init];
     [sectionsArray addObject:array];
     [array release];
     }
     */
}

- (void)viewWillAppear:(BOOL)animated
{
	[tlbView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    AlarmAndClockAppDelegate *delegate = (AlarmAndClockAppDelegate*)[[UIApplication sharedApplication] delegate];
    delegate.m_DisplaySoundStatus = TRUE;
    
    if (self.audioPlayer)
        [self.audioPlayer stop];
    [Database scheduleAlarmNotification];
}
- (void)done:(UIBarButtonItem *)sender
{
	[self dismissModalViewControllerAnimated:YES];
}

- (void)changeVolume:(UISlider *)sender
{
	AlarmInfo* alarmInfo = (AlarmInfo*)[alarmArray objectAtIndex:nSelectAlarm];
	alarmInfo.volume = sender.value;
	[Database updateAlarmInfo:alarmInfo];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
	return [sectionsArray count];            
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (section == 0)
		return @"";
	if (section == 1)
		return @"Sounds";
	return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	NSArray *subArray= [sectionsArray objectAtIndex:section];            
	return [subArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	static NSString *CellIdentifier = @"ImageCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];		
	}
	
	NSArray* views = [cell.contentView subviews];
	for (UIView* subView in views) {
		[subView removeFromSuperview];
	}
	
	if (indexPath.section == 0) {
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		UILabel *label=[[UILabel alloc]init];
		label.backgroundColor = [UIColor clearColor];
		label.textColor = [UIColor blackColor];
		label.frame=CGRectMake(10, 0, 100, 40);
		label.font = [UIFont boldSystemFontOfSize:15];
		
		NSMutableArray *subArray = [sectionsArray objectAtIndex:indexPath.section];
		label.text= (NSString*)[subArray objectAtIndex:indexPath.row];
		[cell.contentView addSubview:label];
		[label release];
		
		if (nSelectAlarm == -1)
			nSelectAlarm = [alarmArray count]-1;
		
		AlarmInfo* alarmInfo = (AlarmInfo*)[alarmArray objectAtIndex:nSelectAlarm];
		soundVolume = [[UISlider alloc] initWithFrame:CGRectMake(120, 8, 170, 10)];
		soundVolume.minimumValue = 0.0;
        soundVolume.maximumValue = 100.0;
		[soundVolume setValue:alarmInfo.volume animated:NO];
		[soundVolume addTarget:self action:@selector(changeVolume:) forControlEvents:UIControlEventValueChanged];
		[cell.contentView addSubview:soundVolume];
		
	}
	if (indexPath.section == 1) {
		cell.selectionStyle = UITableViewCellSelectionStyleBlue;	
		cell.accessoryType = UITableViewCellAccessoryNone;
		
		AlarmInfo* alarmInfo = (AlarmInfo*)[alarmArray objectAtIndex:nSelectAlarm];
		if (alarmInfo.sound == indexPath.row)
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
		
		NSMutableArray *subArray = [sectionsArray objectAtIndex:indexPath.section];
		cell.textLabel.text = (NSString*)[subArray objectAtIndex:indexPath.row];
	}
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tlbView deselectRowAtIndexPath:indexPath animated:YES];
	
	if (indexPath.section == 1) {
        
		if (nSelectAlarm == -1)
			nSelectAlarm = [alarmArray count]-1;
		AlarmInfo* alarmInfo = (AlarmInfo*)[alarmArray objectAtIndex:nSelectAlarm];
		alarmInfo.sound = indexPath.row;
		[Database updateAlarmInfo:alarmInfo];
        [tlbView reloadData];
        if (self.audioPlayer != nil)
            [self.audioPlayer stop];
        NSString *soundPath = [[NSBundle mainBundle] pathForResource:[alarmSoundArray objectAtIndex:indexPath.row] ofType:@"caf"];
        NSURL *soundURL = [[NSURL alloc] initFileURLWithPath:soundPath];
        self.audioPlayer = [[[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:nil] autorelease];
        audioPlayer.numberOfLoops = 1;
        [audioPlayer prepareToPlay];
        [audioPlayer play];
	}
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait) || (UIInterfaceOrientationPortraitUpsideDown == UIInterfaceOrientationLandscapeRight);
}


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
	[tlbView release];
	[doneBt release];
	[soundVolume release];
	[sectionsArray release];
    [audioPlayer release];
    [super dealloc];
}


@end
