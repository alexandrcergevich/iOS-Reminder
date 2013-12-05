//
//  DisplayViewController.m
//  AlarmAndClock
//
//  Created by Alexandr on 11/2/11.
//  Copyright 2011 12345. All rights reserved.
//

#import "DisplayViewController.h"
#import "Database.h"
#import "WeatherAgent.h"
@implementation DisplayViewController

@synthesize tlbView;
@synthesize doneBt;
@synthesize sliderBrightness;
@synthesize sectionsArray;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	doneBt = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
	
	self.navigationItem.rightBarButtonItem = doneBt;
	self.navigationItem.title = @"Display";
	
	NSMutableArray* array1 = [[NSMutableArray alloc] initWithCapacity:7];
	[array1 addObject:@"Show Seconds"];
	[array1 addObject:@"Show Day"];
	[array1 addObject:@"Show Weather"];
	[array1 addObject:@"Show Next Alarm"];
	[array1 addObject:@"Time Format"];
	[array1 addObject:@"Temperature Unit"];
	[array1 addObject:@"Distance Unit"];
	
	NSMutableArray* array2 = [[NSMutableArray alloc] initWithCapacity:7];
	[array2 addObject:@"Brightness"];
	
	sectionsArray = [[NSMutableArray alloc] initWithCapacity:2];
	[sectionsArray addObject:array1];
	[sectionsArray addObject:array2];
	
	[array1 release];
	[array2 release];
	
	for (int index = 0; index < 2; index++) {
		NSMutableArray *array = [[NSMutableArray alloc] init];
		[sectionsArray addObject:array];
		[array release];
	}	
}

- (void)viewWillAppear:(BOOL)animated
{
	[tlbView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated 
{

}

- (void) changeBright:(UISlider *) sender
{
	DisplayInfo* displayInfo = [[DisplayInfo alloc] init];
	[Database getDisplayInfo:displayInfo];
	displayInfo.bright = sender.value;
	[Database updateDisplayInfo:displayInfo];
	[displayInfo release];
}

- (void) switchAction:(UISwitch *)sender
{
	DisplayInfo* displayInfo = [[DisplayInfo alloc] init];
	[Database getDisplayInfo:displayInfo];
	switch (sender.tag) {
		case 0:
			displayInfo.show_second = sender.on;
			break;
		case 1:
			displayInfo.show_day = sender.on;
			break;
		case 2:
			displayInfo.show_weather = sender.on;
			break;
		case 3:
			displayInfo.show_next_alarm = sender.on;
			break;
	}
	[Database updateDisplayInfo:displayInfo];
	[displayInfo release];
}

- (void) selectAction:(UISegmentedControl*)sender
{
	DisplayInfo* displayInfo = [[DisplayInfo alloc] init];
	[Database getDisplayInfo:displayInfo];
	switch (sender.tag) {
		case 4:
			displayInfo.time_format = sender.selectedSegmentIndex;
			break;
		case 5:
			displayInfo.temp_unit = sender.selectedSegmentIndex;
			break;
		case 6:
			displayInfo.dist_unit = sender.selectedSegmentIndex;
			break;
	}
	[Database updateDisplayInfo:displayInfo];
	[displayInfo release];
}

- (void)done:(UIBarButtonItem *)sender
{
	[self dismissModalViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
	return [sectionsArray count];            
}


-(NSString*)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
//	if (section == 1)
//		return @"Swipe up and down across the screen while the app is running to change brightness";
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
		cell.accessoryType = UITableViewCellAccessoryNone;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	NSArray* views = [cell.contentView subviews];
	for (UIView* subView in views) {
		[subView removeFromSuperview];
	}
	
	if (indexPath.section == 0) {

		UILabel *label=[[UILabel alloc]init];
		label.backgroundColor = [UIColor clearColor];
		label.textColor = [UIColor blackColor];
		label.frame=CGRectMake(10, 0, 140, 40);
		label.font = [UIFont boldSystemFontOfSize:15];
		
		NSMutableArray *subArray = [sectionsArray objectAtIndex:indexPath.section];
		label.text= (NSString*)[subArray objectAtIndex:indexPath.row];
		[cell.contentView addSubview:label];
		[label release];
		
		DisplayInfo* displayInfo = [[DisplayInfo alloc] init];
		[Database getDisplayInfo:displayInfo];
		
		if (indexPath.row >= 0 && indexPath.row <= 3) {
			UISwitch* onOff = [[UISwitch alloc] initWithFrame:CGRectMake(190, 7, 60, 40)];
			onOff.tag = indexPath.row;
			
			switch (indexPath.row) {
				case 0:
					[onOff setOn:displayInfo.show_second animated:NO];
					break;
				case 1:
					[onOff setOn:displayInfo.show_day animated:NO];
					break;
				case 2:
					[onOff setOn:displayInfo.show_weather animated:NO];
					break;
				case 3:
					[onOff setOn:displayInfo.show_next_alarm animated:NO];
					break;
			}
			
			[onOff addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
			[cell.contentView addSubview:onOff];
			[onOff release];
		}
		if (indexPath.row == 4) {
			UISegmentedControl* segmentControl = [[UISegmentedControl alloc] initWithFrame:CGRectMake(170, 5, 120, 30)];
			segmentControl.segmentedControlStyle = UISegmentedControlStyleBar;
			[segmentControl insertSegmentWithTitle:@"12h" atIndex:0 animated:NO];
			[segmentControl insertSegmentWithTitle:@"24h" atIndex:1 animated:NO];
			segmentControl.selectedSegmentIndex = displayInfo.time_format;
			segmentControl.tag = indexPath.row;
			[segmentControl addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventValueChanged];
			[cell.contentView addSubview:segmentControl];
			[segmentControl release];
		}
		if (indexPath.row == 5) {
			UISegmentedControl* segmentControl = [[UISegmentedControl alloc] initWithFrame:CGRectMake(170, 5, 120, 30)];
			segmentControl.segmentedControlStyle = UISegmentedControlStyleBar;
			[segmentControl insertSegmentWithTitle:@"F" atIndex:0 animated:NO];
			[segmentControl insertSegmentWithTitle:@"C" atIndex:1 animated:NO];
			segmentControl.selectedSegmentIndex = displayInfo.temp_unit;
			segmentControl.tag = indexPath.row;
			[segmentControl addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventValueChanged];
			[cell.contentView addSubview:segmentControl];
			[segmentControl release];
		}
		if (indexPath.row == 6) {
			UISegmentedControl* segmentControl = [[UISegmentedControl alloc] initWithFrame:CGRectMake(140, 5, 150, 30)];
			segmentControl.segmentedControlStyle = UISegmentedControlStyleBar;
			[segmentControl insertSegmentWithTitle:@"Miles" atIndex:0 animated:NO];
			[segmentControl insertSegmentWithTitle:@"Kilometers" atIndex:1 animated:NO];
			segmentControl.selectedSegmentIndex = displayInfo.dist_unit;
			segmentControl.tag = indexPath.row;
			[segmentControl addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventValueChanged];
			[cell.contentView addSubview:segmentControl];
			[segmentControl release];
		}
		
		[displayInfo release];
	}
	if (indexPath.section == 1) {
		
		UILabel *label=[[UILabel alloc]init];
		label.backgroundColor = [UIColor clearColor];
		label.textColor = [UIColor blackColor];
		label.frame=CGRectMake(10, 0, 100, 40);
		label.font = [UIFont boldSystemFontOfSize:15];
		
		NSMutableArray *subArray = [sectionsArray objectAtIndex:indexPath.section];
		label.text= (NSString*)[subArray objectAtIndex:indexPath.row];
		[cell.contentView addSubview:label];
		[label release];
		
		DisplayInfo* displayInfo = [[DisplayInfo alloc] init];
		[Database getDisplayInfo:displayInfo];
		sliderBrightness = [[UISlider alloc] initWithFrame:CGRectMake(120, 8, 170, 10)];
		sliderBrightness.minimumValue = 0;
        sliderBrightness.maximumValue = 50;
		[sliderBrightness setValue:displayInfo.bright animated:NO];
		[sliderBrightness addTarget:self action:@selector(changeBright:) forControlEvents:UIControlEventValueChanged];
		[cell.contentView addSubview:sliderBrightness];
		[displayInfo release];
	}
	
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
	[sliderBrightness release];
    [super dealloc];
}


@end
