//
//  UITappingScrollView.h
//  AlarmAndClock
//
//  Created by Alexandr on 11/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClockViewController.h"
@class ClockViewController;
@interface UITappingScrollView : UIScrollView

@property (nonatomic, assign) ClockViewController *touchDelegate;
@end
