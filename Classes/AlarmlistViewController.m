//
//  AlarmlistViewController.m
//  AlarmAndClock
//
//  Created by Alexandr on 10/31/11.
//  Copyright 2011 12345. All rights reserved.
//

#import "AlarmlistViewController.h"
#import "AlarmViewController.h"
#import "Database.h"
#import "AlarmAndClockAppDelegate.h"

@interface AlarmlistViewController (Private)

- (void) reloadData;
- (void) updateButtons;

@end

@implementation AlarmlistViewController

@synthesize tlbView, editBt, doneBt;

- (void)viewDidLoad
{
	[super viewDidLoad];	
	
	editBt = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(edit:)];
	doneBt = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];

	self.navigationItem.rightBarButtonItem = editBt;
//	self.navigationItem.title = @"Alarm List";
    self.navigationItem.title = @"Reminder List";
	
}

-(void) viewWillAppear: (BOOL)animated
{
	[self reloadData];
	[self updateButtons];
	[tlbView reloadData];

}

- (void) addAlarmAction:(id)sender
{
	AlarmViewController* alarmSet = [[[AlarmViewController alloc] init] autorelease];
	alarmSet.nSelectAlarm = -1;
	[self.navigationController pushViewController:alarmSet animated:YES];
}

- (void)edit:(UIBarButtonItem *)sender
{
	self.navigationItem.rightBarButtonItem = doneBt;
	[super setEditing:YES animated:YES];
	[tlbView setEditing:YES animated:YES];
}

- (void)done:(UIBarButtonItem *)sender
{
//    if ([alarmArray count] == 0)
//        [self.navigationController dismissModalViewControllerAnimated:YES];
	self.navigationItem.rightBarButtonItem = editBt;
	[super setEditing:NO animated:YES];
	[tlbView setEditing:NO animated:YES];
    
    
    
}

- (void) updateButtons
{
	if ([alarmArray count] == 0)
	{
		editBt.enabled = NO;
		self.navigationItem.leftBarButtonItem.enabled = NO;
	}
	else 
	{
		editBt.enabled = YES;
		self.navigationItem.leftBarButtonItem.enabled = YES;		
	}	
}

- (void) reloadData
{
	[self updateButtons];
}

- (void) enableAlarm:(UISwitch *)sender
{
	AlarmInfo* alarmInfo = (AlarmInfo*)[alarmArray objectAtIndex:sender.tag];
	alarmInfo.enable = sender.on;
}

- (UITableViewCellEditingStyle) tableView:(UITableView *) tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{   
	if(self.editing == NO || !indexPath|| [alarmArray count] == 0)
    {
		return UITableViewCellEditingStyleNone;
    }
	
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	AlarmInfo* alarmInfo = (AlarmInfo*)[alarmArray objectAtIndex:indexPath.row];
	[Database delAlarmInfo:alarmInfo.id_value];
	[alarmArray removeObjectAtIndex:indexPath.row+1];
	[Database scheduleAlarmNotification];
	[self updateButtons];
	[tlbView reloadData];
}

-(void) tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
	[tlbView deselectRowAtIndexPath:indexPath animated:YES];
	
	AlarmViewController* alarm = [[[AlarmViewController alloc] init] autorelease];
	alarm.nSelectAlarm = indexPath.row;
	[self.navigationController pushViewController:alarm animated:YES];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    AlarmViewController* alarm = [[[AlarmViewController alloc] init] autorelease];
	alarm.nSelectAlarm = indexPath.row;
	[self.navigationController pushViewController:alarm animated:YES];
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [alarmArray count]-1;
}

- (CGFloat) tableView: (UITableView *)tableView heightForRowAtIndexPath: (NSIndexPath *)indexPath
{	
	return 80;	
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:nil] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
		cell.selectionStyle = UITableViewCellSelectionStyleBlue;
	}
	
	NSArray* views = [cell.contentView subviews];
	for (UIView* subView in views) {
		[subView removeFromSuperview];
	}
	
	AlarmInfo* alarmInfo = (AlarmInfo*)[alarmArray objectAtIndex:indexPath.row+1];
	
	UILabel *label=[[[UILabel alloc]init] autorelease];
	label.backgroundColor = [UIColor clearColor];
	label.textColor = [UIColor blackColor];
	label.frame=CGRectMake(10, 0, 90, 40);
	label.font = [UIFont fontWithName:@"Verdana-Bold" size:26];
	
	DisplayInfo* displayInfo = [[DisplayInfo alloc] init];
	[Database getDisplayInfo:displayInfo];
	
    NSLog(@"time_format ----> %d", displayInfo.time_format);
    NSLog(@"indexPath+1 -> %d", indexPath.row+1);
    NSLog(@"alarmInfo hour minute am -> %d %d %d", alarmInfo.hour, alarmInfo.minute, alarmInfo.am);
	if (displayInfo.time_format) {
		label.text= [NSString stringWithFormat:@"%02d:%02d", alarmInfo.hour, alarmInfo.minute];	
	}
	else {
		if ((alarmInfo.hour == 0 && alarmInfo.am==0) || (alarmInfo.hour == 12 && alarmInfo.am==1)) {
			label.text= [NSString stringWithFormat:@"12:%02d", alarmInfo.minute];
		}
		else {
			label.text= [NSString stringWithFormat:@"%02d:%02d", (alarmInfo.hour<12?alarmInfo.hour:alarmInfo.hour-12), alarmInfo.minute];
		}			
	}
	
	[cell.contentView addSubview:label];

	if (displayInfo.time_format == 0) {
		label=[[UILabel alloc]init];
		label.backgroundColor = [UIColor clearColor];
		label.textColor = [UIColor blackColor];
		label.frame=CGRectMake(100, 15, 30, 25);
		label.font = [UIFont fontWithName:@"Verdana-Bold" size:15];
        NSLog(@"%d", alarmInfo.am);
		label.text= [NSString stringWithFormat:(alarmInfo.am==0?@"AM":@"PM")];
		[cell.contentView addSubview:label];
	}
	[displayInfo release];
	
	UISwitch* onOff = [[[UISwitch alloc] initWithFrame:CGRectMake(160, 7, 60, 40)] autorelease];
	onOff.tag = indexPath.row;
	[onOff setOn:alarmInfo.enable animated:NO];
	[onOff addTarget:self action:@selector(enableAlarm:) forControlEvents:UIControlEventValueChanged];
	
	label=[[[UILabel alloc]init] autorelease];
	label.backgroundColor = [UIColor clearColor];
	label.textColor = [UIColor blackColor];
	label.frame=CGRectMake(10, 40, 280, 20);
	label.font = [UIFont systemFontOfSize:14];
	if ([alarmInfo.message isEqualToString:@""])
		label.text= @"No notes have been added";
	else
		label.text= alarmInfo.message;
	[cell.contentView addSubview:label];
	
	label=[[[UILabel alloc]init] autorelease];
	label.backgroundColor = [UIColor clearColor];
	label.textColor = [UIColor grayColor];
	label.frame=CGRectMake(10, 60, 280, 20);
	label.font = [UIFont systemFontOfSize:14];
	if ([alarmInfo.message isEqualToString:@"Never"])
		label.text= @"Tomorrow";
	else
		label.text= alarmInfo.repeat;
	[cell.contentView addSubview:label];
    
    //G.W.
//    AlarmAndClockAppDelegate *delegate = (AlarmAndClockAppDelegate *)[[UIApplication sharedApplication] delegate];
//    
//    label=[[[UILabel alloc]init] autorelease];
//	label.backgroundColor = [UIColor clearColor];
//	label.textColor = [UIColor grayColor];
//	label.frame=CGRectMake(160, 10, 280, 20);
//	label.font = [UIFont systemFontOfSize:14];
//    label.text = [NSString stringWithFormat:@"StartTime %02d:%02d", delegate.startHour, delegate.startMinute];
//    NSLog(@"startHour-> %02d  startMinute-> %02d", delegate.startHour, delegate.startMinute);
//	[cell.contentView addSubview:label];
	
	return cell;
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
	[editBt release];
	[doneBt release];
    [super dealloc];
}


@end
