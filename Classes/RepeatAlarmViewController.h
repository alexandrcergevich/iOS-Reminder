//
//  RepeatAlarmViewController.h
//  AlarmAndClock
//
//  Created by Alexandr on 11/2/11.
//  Copyright 2011 12345. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RepeatAlarmViewController : UIViewController<UITableViewDelegate> {

}

@property (nonatomic, retain) IBOutlet UITableView* tlbView;
@property (nonatomic, retain) UIBarButtonItem *doneBt;

@property (nonatomic, retain) NSMutableArray* arrayWeek;
@property (nonatomic, retain) NSMutableArray* arraySelect;
@property (nonatomic, retain) NSMutableArray* arrayValue;
@property (nonatomic, assign) int	nSelectAlarm;
@property (nonatomic, retain) NSMutableString*	strRepeatAlarm;

@end
