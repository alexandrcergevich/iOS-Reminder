//
//  AdvancedViewController.m
//  AlarmAndClock
//
//  Created by Alexandr on 11/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AdvancedViewController.h"
#import "PostponeSelectController.h"
#import "StockMarketSelectController.h"
#import "CurrencySelectController.h"
#import "StockAgent.h"
#import "Database.h"
#import "WeatherAgent.h"

@implementation AdvancedViewController
@synthesize tblAdvanced, searchBar;
@synthesize stockMarketSelectController, currencySelectController, locationSearchController, postponeSelectController;
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
}

- (void)doneAction:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}



/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)viewWillAppear:(BOOL)animated {
	[self.tblAdvanced reloadData];
}
- (void)switchAction:(UISwitch *)sender {
	if (sender.tag == 100)
	{
		advancedInfo.background_alarm = sender.on;
	}
	else if (sender.tag == 101)
	{
		advancedInfo.on_plugin = sender.on;
	}
	else if (sender.tag == 102)
	{
		advancedInfo.on_battery = sender.on;
	}
    else if (sender.tag == 103)
        advancedInfo.snooze = sender.on;
	[Database updateAdvancedInfo];
}
#pragma mark -
#pragma mark UITableViewDelegate, UITableViewDatasource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	if (indexPath.section == 1)
	{
		if (indexPath.row == 0)
		{
			self.locationSearchController = [[LocationSearchController alloc] init];
			self.locationSearchController.delegate = self;
			[self.navigationController pushViewController:self.locationSearchController animated:YES];
			[self.locationSearchController release];
	
		}
		else if (indexPath.row == 1)
		{
			self.stockMarketSelectController = [[StockMarketSelectController alloc] init];
			[self.navigationController pushViewController:self.stockMarketSelectController animated:YES];
			[self.stockMarketSelectController release];
			
		}
		else if (indexPath.row == 2)
		{
			self.currencySelectController = [[CurrencySelectController alloc] init];
			[self.navigationController pushViewController:self.currencySelectController animated:YES];
			[self.currencySelectController release];
			
		}
		
	}
	if (indexPath.section == 2)
	{
		if (indexPath.row == 2)
		{
			self.postponeSelectController = [[PostponeSelectController alloc] initWithStyle:UITableViewStylePlain];
			[self.navigationController pushViewController:self.postponeSelectController animated:YES];
			[self.postponeSelectController release];
		}
	}
	
}


- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section == 2)
		return @"Auto-Lock";
	return @"";
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (section == 0)
		return 1;
	if (section == 1)
		return 3;
    if (section == 3)
        return 1;
	return 3;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 1)
		return 64;
	return 44;
		
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	int section = [indexPath section];
	int row = [indexPath row];
	NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d_%d", section, row];
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

	if (cell == nil) {
		if (section == 1)
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		else {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
		}

        //cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:nil] autorelease];
		if (section == 1 || (section == 2 && row == 2) )
		{
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			cell.detailTextLabel.font = [UIFont fontWithName:@"Verdana" size:12];
			cell.detailTextLabel.textColor = [UIColor grayColor];
		}
		else {
			UISwitch *btnSwitch = [[[UISwitch alloc] init] autorelease];
			
			[btnSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
			cell.accessoryView = btnSwitch;
			if (section == 0)
				btnSwitch.tag = 100;
			else if (section == 2)
			{
				if (row == 0)
					btnSwitch.tag = 101;
				else if (row == 1)
					btnSwitch.tag = 102;
			}
            else if (section == 3)
                btnSwitch.tag = 103;
        
		}
		
		cell.selectionStyle = UITableViewCellSelectionStyleBlue;
	}

	if (section == 0)
	{
		cell.textLabel.text = @"Background Alarms";
		UISwitch *btnSwitch = cell.accessoryView;
		[btnSwitch setOn:advancedInfo.background_alarm];
	}
	else if (section == 1)
	{
		if (row == 0)
		{
			cell.textLabel.text = @"Set Location";
			
			cell.detailTextLabel.text = [advancedInfo location_name];
		}
		else if (row == 1)
		{
			cell.textLabel.text = @"Set Stock Market";
			cell.detailTextLabel.text = [[StockAgent sharedStockAgent].stockNameDictionary objectForKey:advancedInfo.stockSymbol] ;
		}
		else if (row == 2)
		{
			cell.textLabel.text = @"Set Currency";
			cell.detailTextLabel.text = advancedInfo.currencyName;
		}
	}
	else if (section == 2)
	{
		if (row == 0)
		{
			cell.textLabel.text = @"When plugged in";
			UISwitch *btnSwitch = cell.accessoryView;
			[btnSwitch setOn:advancedInfo.on_plugin];
		}
		else if (row == 1)
		{
			cell.textLabel.text = @"When on battery";
			UISwitch *btnSwitch = cell.accessoryView;
			[btnSwitch setOn:advancedInfo.on_battery];
		}
		else if (row == 2)
		{
			cell.textLabel.text = @"Postpone";
			if (advancedInfo.postpone <= 0)
				cell.detailTextLabel.text = @"Never";
			else if (advancedInfo.postpone >= 60) {
				cell.detailTextLabel.text = [NSString stringWithFormat:@"%d hour", (advancedInfo.postpone/60)];
			}
			else {
				cell.detailTextLabel.text = [NSString stringWithFormat:@"%d minutes", (advancedInfo.postpone)];
			}

		}
	}
    else if (section == 3)
    {
        cell.textLabel.text = @"Snooze";
        UISwitch *btnSwitch = cell.accessoryView;
        [btnSwitch setOn:advancedInfo.snooze];
    }
		
	return cell;
}
#pragma mark LocationSearchControllerDelegate
- (void)didSelectPlaceItem:(PlaceItem *)placeItem
{
	advancedInfo.location_woeid = placeItem.woeID;
	if (placeItem.addr1 == nil)
		advancedInfo.location_name = [NSString stringWithFormat:@"%@, %@", placeItem.placeName, placeItem.countryName];
	else if ([placeItem.addr1 isEqualToString:placeItem.placeName])
		advancedInfo.location_name = [NSString stringWithFormat:@"%@, %@", placeItem.placeName, placeItem.countryName];
	else 
		advancedInfo.location_name = [NSString stringWithFormat:@"%@, %@, %@", placeItem.placeName, placeItem.addr1, placeItem.countryName];
	
	[Database updateAdvancedInfo];
	DisplayInfo* displayInfo = [[DisplayInfo alloc] init];
	[Database getDisplayInfo:displayInfo];
	[[WeatherAgent sharedWeatherAgent] requestWeatherWithWoeID:advancedInfo.location_woeid andUnit:displayInfo.dist_unit];
	[displayInfo release];
	
}

#pragma mark Memory deallocation
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
    [stockMarketSelectController release];
    [postponeSelectController release];
    [currencySelectController release];
    [locationSearchController release];
	[searchBar release];
	[tblAdvanced release];
    [super dealloc];
}


@end
