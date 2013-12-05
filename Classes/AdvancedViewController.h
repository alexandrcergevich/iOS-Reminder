//
//  AdvancedViewController.h
//  AlarmAndClock
//
//  Created by Alexandr on 11/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationSearchController.h"
@class LocationSearchController;
@class StockMarketSelectController;
@class  CurrencySelectController;
@class PostponeSelectController;
@interface AdvancedViewController : UIViewController 
<UITableViewDelegate, UITableViewDataSource, LocationSearchControllerDelegate> {

}
@property (nonatomic, retain)IBOutlet UITableView *tblAdvanced;
@property (nonatomic, retain)IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain)LocationSearchController *locationSearchController;
@property (nonatomic, retain)StockMarketSelectController *stockMarketSelectController;
@property (nonatomic, retain)CurrencySelectController *currencySelectController;
@property (nonatomic, retain)PostponeSelectController *postponeSelectController;
- (void)switchAction:(UISwitch *)sender;
- (void)doneAction:(id)sender;
@end
