//
//  AlarmlistViewController.h
//  AlarmAndClock
//
//  Created by Alexandr on 10/31/11.
//  Copyright 2011 12345. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AlarmlistViewController : UIViewController<UITableViewDelegate> {

}

@property (nonatomic, retain) IBOutlet UITableView* tlbView;
@property (nonatomic, retain) UIBarButtonItem *editBt;
@property (nonatomic, retain) UIBarButtonItem *doneBt;

- (void) addAlarmAction:(id)sender;

@end
