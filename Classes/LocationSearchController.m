//
//  LocationSearchController.m
//  AlarmAndClock
//
//  Created by Alexandr on 11/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LocationSearchController.h"

@implementation LocationSearchController
@synthesize placeArray, tblSearch, delegate, client, searchBar, hudProgress, locationManager;
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)myLocationAction:(id)sender {

	self.locationManager = [[[CLLocationManager alloc] init] autorelease];
	locationManager.delegate = self;
	locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
	locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
	[locationManager startUpdatingLocation];	
    hudProgress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
 /*
	if (self.placeArray)
		[self.placeArray removeAllObjects];
	[tblSearch reloadData];
	hudProgress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	[self.client cancel];
	[self.client reqPlaceByLocation:@"50.0804,50.6316"];
  */
}

- (void)doneAction:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.placeArray = [NSMutableArray arrayWithCapacity:100];
	self.client = [[[HttpClient alloc] init] autorelease];
	self.client.delegate = self;

	
	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction:)];
	UIBarButtonItem *myLocationButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_nearby.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(myLocationAction:)];
	NSArray *buttons = [NSArray arrayWithObjects: doneButton, myLocationButton, nil];
    
    self.navigationItem.rightBarButtonItems = buttons;
    
	[myLocationButton release];
	[doneButton release]; 
	self.navigationItem.title = @"Settings";
}


- (void) viewWillDisappear:(BOOL)animated {
	[self.client cancelDelegate];
	[hudProgress removeFromSuperview];
	hudProgress = nil;
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
#pragma mark CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
	[manager stopUpdatingLocation];
	double latitude = newLocation.coordinate.latitude;
	double longitude = newLocation.coordinate.longitude;
	NSString *location = [NSString stringWithFormat:@"%f,%f", latitude, longitude];

	if (self.placeArray)
		[self.placeArray removeAllObjects];
	[tblSearch reloadData];
//	hudProgress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	[self.client cancel];
	[self.client reqPlaceByLocation:location];

	
}
#pragma mark UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar1 {
	if (self.placeArray)
		[self.placeArray removeAllObjects];
	[tblSearch reloadData];
	hudProgress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	[self.client cancel];
	[self.client reqPlace:searchBar1.text];
	[self.searchBar resignFirstResponder];
}

#pragma mark DDHttpClientDelegate
- (void)HttpClientSucceeded:(HttpClient*)sender
{
	[hudProgress removeFromSuperview];
	hudProgress = nil;
	
	self.placeArray = [NSMutableArray arrayWithArray:sender.result];
	[tblSearch reloadData];
	
}

- (void)HttpClientFailed:(HttpClient*)sender {
}


#pragma mark UITableViewDelegate

-(void) tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	PlaceItem *placeItem = [placeArray objectAtIndex:indexPath.row];
	[delegate didSelectPlaceItem:placeItem];
	[self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.placeArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];

	}
	PlaceItem *item = [placeArray objectAtIndex:indexPath.row];
	if (item.addr1 == nil)
		cell.textLabel.text = [NSString stringWithFormat:@"%@, %@", item.placeName, item.countryName];
	else if ([item.addr1 isEqualToString:item.placeName])
		cell.textLabel.text = [NSString stringWithFormat:@"%@, %@", item.placeName, item.countryName];
	else 
		cell.textLabel.text = [NSString stringWithFormat:@"%@, %@, %@", item.placeName, item.addr1, item.countryName];
	
	return cell;
}

#pragma mark controller deallocation
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
	[locationManager stopUpdatingLocation];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[locationManager release];
	[placeArray release];
	[tblSearch release];
	[client release];
	[searchBar release];
    [super dealloc];
}


@end
