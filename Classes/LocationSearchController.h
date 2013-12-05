//
//  LocationSearchController.h
//  AlarmAndClock
//
//  Created by Alexandr on 11/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "PlaceItem.h"
#import "HttpClient.h"
#import "MBProgressHUD.h"
@protocol LocationSearchControllerDelegate
- (void)didSelectPlaceItem:(PlaceItem *)placeItem;
@end

@interface LocationSearchController : UIViewController
<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, DDHttpClientDelegate, CLLocationManagerDelegate>{

}
@property (nonatomic, retain) IBOutlet UITableView *tblSearch;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) NSMutableArray *placeArray;
@property (nonatomic, retain) HttpClient *client;
@property (nonatomic, retain) MBProgressHUD *hudProgress;
@property (nonatomic, assign) id<LocationSearchControllerDelegate> delegate;
@property (nonatomic, retain) CLLocationManager *locationManager;
- (void)myLocationAction:(id)sender;
- (void)doneAction:(id)sender;
@end
