//
//  ClockViewController.h
//  AlarmAndClock
//
//  Created by Alexandr on 10/30/11.
//  Copyright 2011 12345. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpClient.h"
#import "WeatherAgent.h"
#import "StockAgent.h"
#import "CurrencyAgent.h"
#import "Database.h"
#import "UITappingScrollView.h"

@class AlarmInfo;
@class UITappingScrollView;
@interface ClockViewController : UIViewController 
<UIScrollViewDelegate, WeatherAgentDelegate, StockAgentDelegate, CurrencyAgentDelegate> {
	int curClockIndex;
	int cyberClockColor;
	int digitalClockColor;
	int grandClockColor;
	int polarClockColor;
	int wordClockColor;
	int timeFormat;
	int temperatureUnit;
	int distanceUnit;
    BOOL bShowedButton;
    BOOL bShowing;
}
@property (nonatomic, retain) DisplayInfo *displayInfo;


@property (nonatomic, retain) AlarmInfo *curAlarmInfo;
// Main Views
@property (nonatomic, retain) IBOutlet UITappingScrollView* scrollView;
@property (nonatomic, retain) IBOutlet UIView *vwCyberView;
@property (nonatomic, retain) IBOutlet UIView *vwDigitalView;
@property (nonatomic, retain) IBOutlet UIView *vwGrandView;
@property (nonatomic, retain) IBOutlet UIView *vwPolarView;
@property (nonatomic, retain) IBOutlet UIView *vwWordView;
// Common Buttons
@property (nonatomic, retain) IBOutlet UIImageView* imgMask;
@property (nonatomic, retain) IBOutlet UIView *vwPanelBottomRight;
@property (nonatomic, retain) IBOutlet UILabel* lblWeather;
@property (nonatomic, retain) IBOutlet UILabel* lblTempH;
@property (nonatomic, retain) IBOutlet UILabel* lblTempL;
@property (nonatomic, retain) IBOutlet UIButton* btnAlarm;
@property (nonatomic, retain) IBOutlet UILabel* lblAlarm;
@property (nonatomic, retain) IBOutlet UIButton* btnSleep;
@property (nonatomic, retain) IBOutlet UILabel* lblRate;
@property (nonatomic, retain) IBOutlet UILabel* lblPercent;
@property (nonatomic, retain) IBOutlet UILabel* lblValue;
@property (nonatomic, retain) IBOutlet UIView *vwFinacialBar;
@property (nonatomic, retain) IBOutlet UIImageView * imgFinancialBar;
@property (nonatomic, retain) IBOutlet UIButton *btnInfo;
@property (nonatomic, retain) IBOutlet UIButton *btnColor;
@property (nonatomic, retain) IBOutlet UIButton *btnSetting;
@property (nonatomic, retain) IBOutlet UIButton *btnFinance;
@property (nonatomic, retain) IBOutlet UIImageView *imgThermoIcon;
// Cyber Clock

@property (nonatomic, retain) IBOutlet UIImageView* imgWeather;
@property (nonatomic, retain) IBOutlet UIImageView *imgCyberHour;
@property (nonatomic, retain) IBOutlet UIImageView *imgCyberMinute;
@property (nonatomic, retain) IBOutlet UIImageView *imgCyberSecond;
@property (nonatomic, retain) IBOutlet UIImageView *imgCyberBackground;
@property (nonatomic, retain) IBOutlet UIImageView *imgCyberClock;
@property (nonatomic, retain) IBOutlet UIImageView *imgCyberMinuteCover;
@property (nonatomic, retain) IBOutlet UIImageView *imgCyberHourCover;
@property (nonatomic, retain) IBOutlet UILabel *lblCyberDay;
@property (nonatomic, retain) IBOutlet UILabel *lblCyberWeekday;


//Digital Clock
@property (nonatomic, retain) IBOutlet UIImageView *imgDigitalBackground;
@property (nonatomic, retain) IBOutlet UILabel *lblDigitalHour;
@property (nonatomic, retain) IBOutlet UILabel *lblDigitalMinute;
@property (nonatomic, retain) IBOutlet UILabel *lblDigitalSecond;
@property (nonatomic, retain) IBOutlet UILabel *lblDigitalHourBackground;
@property (nonatomic, retain) IBOutlet UILabel *lblDigitalMinuteBackground;
@property (nonatomic, retain) IBOutlet UILabel *lblDigitalSecondBackground;
@property (nonatomic, retain) IBOutlet UILabel *lblDigitalColon;
@property (nonatomic, retain) IBOutlet UILabel *lblDigitalMorning;
@property (nonatomic, retain) IBOutlet UILabel *lblDigitalSlash;

@property (nonatomic, retain) IBOutlet UILabel *lblDigitalMonth;
@property (nonatomic, retain) IBOutlet UILabel *lblDigitalDay;
@property (nonatomic, retain) IBOutlet UILabel *lblDigitalWeekday;

@property (nonatomic, retain) IBOutlet UILabel *lblDigitalMonthCaption;

@property (nonatomic, retain) IBOutlet UILabel *lblDigitalDayCaption;
@property (nonatomic, retain) IBOutlet UILabel *lblDigitalWeekdayCaption;

//Grand Clock
@property (nonatomic, retain) IBOutlet UIImageView *imgGrandHour;
@property (nonatomic, retain) IBOutlet UIImageView *imgGrandMinute;
@property (nonatomic, retain) IBOutlet UIImageView *imgGrandSecond;
@property (nonatomic, retain) IBOutlet UIImageView *imgGrandBackground;
@property (nonatomic, retain) IBOutlet UIImageView *imgGrandClock;
@property (nonatomic, retain) IBOutlet UIImageView *imgGrandSecondCover;
@property (nonatomic, retain) IBOutlet UILabel *lblGrandDay;
@property (nonatomic, retain) IBOutlet UILabel *lblGrandWeekday;

//Polar Clock
@property (nonatomic, retain) IBOutlet UIView *vwPolarClockContainer;
@property (nonatomic, retain) IBOutlet UIImageView *imgPolarHour;
@property (nonatomic, retain) IBOutlet UIImageView *imgPolarMinute;
@property (nonatomic, retain) IBOutlet UIImageView *imgPolarSecond;
@property (nonatomic, retain) IBOutlet UIImageView *imgPolarWeekday;
@property (nonatomic, retain) IBOutlet UIImageView *imgPolarDay;

@property (nonatomic, retain) IBOutlet UIView *vwPolarHour;
@property (nonatomic, retain) IBOutlet UIView *vwPolarMinute;
@property (nonatomic, retain) IBOutlet UIView *vwPolarSecond;
@property (nonatomic, retain) IBOutlet UIView *vwPolarWeekday;
@property (nonatomic, retain) IBOutlet UIView *vwPolarDay;

@property (nonatomic, retain) IBOutlet UILabel *lblPolarMonth;
@property (nonatomic, retain) IBOutlet UILabel *lblPolarDay1;
@property (nonatomic, retain) IBOutlet UILabel *lblPolarDay2;
@property (nonatomic, retain) IBOutlet UILabel *lblPolarWeekday;
@property (nonatomic, retain) IBOutlet UILabel *lblPolarHour1;
@property (nonatomic, retain) IBOutlet UILabel *lblPolarHour2;
@property (nonatomic, retain) IBOutlet UILabel *lblPolarMinute1;
@property (nonatomic, retain) IBOutlet UILabel *lblPolarMinute2;
@property (nonatomic, retain) IBOutlet UILabel *lblPolarSecond1;
@property (nonatomic, retain) IBOutlet UILabel *lblPolarSecond2;


//WordClock

@property (nonatomic, retain) IBOutlet UIImageView *imgWordBackground;
@property (nonatomic, retain) IBOutlet UIImageView *imgWordClockBackground;
@property (nonatomic, retain) IBOutlet UIImageView *imgWordFinanceBar;
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
@property (nonatomic, retain) NSMutableArray *tailViewList;
//Clock Setting Functions
- (void) setDigitClock;
- (void) setCyberClock;
- (void) setGrandClock;
- (void) setPolarClock;
- (void) setWordClock;
- (void) setDigitalClockColor:(int)colorIndex;
- (void) setCyberClockColor:(int)colorIndex;
- (void) setGrandClockColor:(int)colorIndex;
- (void) setPolarClockColor:(int)colorIndex;
- (void) setWordClockColor:(int)colorIndex;
- (void) doAlarm;
//Others
@property (nonatomic, retain) NSMutableArray* arrayValue;
- (void) moveAndShowButtons:(int) offset;
- (void) setCommonButtons:(int) offset;
- (void) adjustFinancialBarPosition:(UIInterfaceOrientation )orientation;

- (IBAction) settingAction:(id)sender;
- (IBAction) infoAction:(id)sender;
- (IBAction) alarmAction:(id)sender;
- (IBAction) colorAction:(id)sender;
- (IBAction) sleepAction:(id)sender;
- (IBAction) financeAction:(id)sender;
- (void) adjustClockLayoutWithOrientation:(UIInterfaceOrientation)orientation;
- (void) didTouch;
- (void) timeChanged:(int)hour Min:(int)minute Sec:(int)second animated:(BOOL)animated;
- (void) dateChanged:(int)year month:(int)month day:(int)day weekday:(int)weekday animated:(BOOL)animated;
- (NSString *) digitString:(int)number;

//Applying Setting
- (void) applyDisplayInfo;


@end
