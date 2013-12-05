//
//  TestController.h
//  AlarmAndClock
//
//  Created by Alexandr on 11/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TestController : UIViewController {

}

@property (nonatomic, retain) IBOutlet UIImageView *imgWordBackground;
@property (nonatomic, retain) IBOutlet UIImageView *imgWordClockBackground;
@property (nonatomic, retain) IBOutlet UILabel *lblWordHour;
@property (nonatomic, retain) IBOutlet UILabel *lblWordMinute;
@property (nonatomic, retain) IBOutlet UILabel *lblWordSecond;
@property (nonatomic, retain) IBOutlet UILabel *lblWordMorning;

@property (nonatomic, retain) IBOutlet UILabel *lblWordYear;
@property (nonatomic, retain) IBOutlet UILabel *lblWordMonth;
@property (nonatomic, retain) IBOutlet UILabel *lblWordDay;
@property (nonatomic, retain) IBOutlet UILabel *lblWordWeekday;

@property (nonatomic, retain) IBOutlet UILabel *lblWordHourCaption;
@property (nonatomic, retain) IBOutlet UILabel *lblWordMinuteCaption;
@property (nonatomic, retain) IBOutlet UILabel *lblWordSecondCaption;



- (void) setWordClock;
- (void) setClockDigitsColor:(UIColor *)color;
@end
