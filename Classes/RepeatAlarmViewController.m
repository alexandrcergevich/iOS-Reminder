//
//  RepeatAlarmViewController.m
//  AlarmAndClock
//
//  Created by Alexandr on 11/2/11.
//  Copyright 2011 12345. All rights reserved.
//

#import "RepeatAlarmViewController.h"
#import "Global.h"
#import "Database.h"
#import "AlarmViewController.h"
#import "AlarmAndClockAppDelegate.h"

@implementation RepeatAlarmViewController

@synthesize tlbView;
@synthesize doneBt;
@synthesize arrayWeek;
@synthesize arraySelect;
@synthesize arrayValue;
@synthesize nSelectAlarm;
@synthesize strRepeatAlarm;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	strRepeatAlarm = [NSMutableString new];
	
//	doneBt = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
//	
//	self.navigationItem.rightBarButtonItem = doneBt;
    //G.W.
//	self.navigationItem.title = @"Repeat Alarm";
    self.navigationItem.title = @"Repeat Days";
	
	arraySelect = [[NSMutableArray alloc] initWithCapacity:7];
	[arraySelect addObject:@""];
	[arraySelect addObject:@""];
	[arraySelect addObject:@""];
	[arraySelect addObject:@""];
	[arraySelect addObject:@""];
	[arraySelect addObject:@""];
	[arraySelect addObject:@""];
	
	arrayValue = [[NSMutableArray alloc] initWithCapacity:7];
	[arrayValue addObject:@"Sun"];
	[arrayValue addObject:@"Mon"];
	[arrayValue addObject:@"Tue"];
	[arrayValue addObject:@"Wed"];
	[arrayValue addObject:@"Thu"];
	[arrayValue addObject:@"Fri"];
	[arrayValue addObject:@"Sat"];
	
	arrayWeek = [[NSMutableArray alloc] initWithCapacity:7];
	[arrayWeek addObject:@"Every Sunday"];
	[arrayWeek addObject:@"Every Monday"];
	[arrayWeek addObject:@"Every Tuesday"];
	[arrayWeek addObject:@"Every Wednesday"];
	[arrayWeek addObject:@"Every Thursday"];
	[arrayWeek addObject:@"Every Friday"];
	[arrayWeek addObject:@"Every Saturday"];
	
	[tlbView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
	if (nSelectAlarm != -1) {
		AlarmInfo* alarmInfo = (AlarmInfo*)[alarmArray objectAtIndex:nSelectAlarm];
		[strRepeatAlarm setString:alarmInfo.repeat];
		
		int i = 0;
		if ([strRepeatAlarm isEqualToString:@"Every Day"]) {
			for (NSString* item in arrayValue) {
				[arraySelect replaceObjectAtIndex:i withObject:[arrayValue objectAtIndex:i]];
				i ++;
			}
		}
		else {
			NSArray* arr = [strRepeatAlarm componentsSeparatedByString:@" "];
			for (NSString* item in arr) {
				int idx = [arrayValue indexOfObject:item];
				if (idx < [arraySelect count])
					[arraySelect replaceObjectAtIndex:idx withObject:item];
			}
		}
		
		[tlbView reloadData];
	}
}

- (void)viewWillDisappear:(BOOL)animated
{
    AlarmAndClockAppDelegate *delegate = (AlarmAndClockAppDelegate*)[[UIApplication sharedApplication] delegate];
    delegate.m_DisplayRepeatStatus = TRUE;
    
	[strRepeatAlarm setString:@""];
	int checkAll = 0;
	for (NSString* item in arraySelect) {
		if ([item isEqualToString:@""] == NO) {
			checkAll ++;
			[strRepeatAlarm appendString:[NSString stringWithFormat:@"%@ ", item]];
		}
	}
	
	if (checkAll == [arrayWeek count])
		[strRepeatAlarm setString:@"Every Day"];
	if (checkAll == 0)
		[strRepeatAlarm setString:@"Never"];
	
	if (nSelectAlarm == -1)
		nSelectAlarm = [alarmArray count]-1;
	AlarmInfo* alarmInfo = (AlarmInfo*)[alarmArray objectAtIndex:nSelectAlarm];
	alarmInfo.repeat = strRepeatAlarm;
	[Database updateAlarmInfo:alarmInfo];	
}

- (void)done:(UIBarButtonItem *)sender
{
	[self dismissModalViewControllerAnimated:YES];
}

-(void) tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
	[tlbView deselectRowAtIndexPath:indexPath animated:YES];

	UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
	if (cell.accessoryType == UITableViewCellAccessoryNone) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
		[arraySelect replaceObjectAtIndex:indexPath.row withObject:[arrayValue objectAtIndex:indexPath.row]];
	}
	else {
		cell.accessoryType = UITableViewCellAccessoryNone;
		[arraySelect replaceObjectAtIndex:indexPath.row withObject:@""];
	}
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [arrayWeek count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:nil] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleBlue;
	}
	
	cell.textLabel.text = (NSString*)[arrayWeek objectAtIndex:indexPath.row];
	
	if ([[arraySelect objectAtIndex:indexPath.row] isEqualToString:@""])
		cell.accessoryType = UITableViewCellAccessoryNone;
	else
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	
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
	[doneBt release];
	[arrayWeek release];
	[arraySelect release];
	[arrayValue release];
    [super dealloc];
}


@end
