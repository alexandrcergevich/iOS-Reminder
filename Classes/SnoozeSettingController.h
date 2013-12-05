//
//  SnoozeSettingController.h
//  AlarmAndClock
//
//  Created by Alexandr on 11/15/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SnoozeSettingController : UIViewController
<UITableViewDataSource, UITableViewDelegate>
{
    
}
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property int selectAlarmNo;

@end
