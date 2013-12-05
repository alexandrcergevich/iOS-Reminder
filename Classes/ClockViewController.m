//
//  ClockViewController.m
//  AlarmAndClock
//
//  Created by Alexandr on 10/30/11.
//  Copyright 2011 12345. All rights reserved.
//

#import "ClockViewController.h"
#import "SettingViewController.h"
#import "AdvancedViewController.h"
#import "SleepViewController.h"
#import "StockMarketSelectController.h"
#import "AlarmlistViewController.h"
#import "AlarmViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "InfoMainController.h"

#import "infoceViewController.h"
#ifndef M_PI 
#define M_PI 3.14159265358979323846264338327950288
#endif

#define DEGREES_TO_RANDIANS(angle) (angle/180*M_PI)

@implementation ClockViewController
//Main views
@synthesize curAlarmInfo, displayInfo, imgFinancialBar;
@synthesize vwCyberView, vwDigitalView, vwGrandView, vwPolarView, vwWordView;
// Common Clock
@synthesize scrollView, imgWeather, imgMask, lblWeather, lblTempH, vwPanelBottomRight;
@synthesize lblTempL, btnAlarm, lblAlarm, btnSleep, lblRate, lblPercent, btnFinance       ;
@synthesize btnColor, btnInfo, btnSetting, imgThermoIcon, lblValue, arrayValue;
//Cyber Clock
@synthesize imgCyberHour, imgCyberMinute, imgCyberSecond, vwFinacialBar, imgCyberClock;
@synthesize imgCyberBackground, imgCyberMinuteCover, imgCyberHourCover, lblCyberDay, lblCyberWeekday;

//Digital Clock
@synthesize imgDigitalBackground, lblDigitalHour, lblDigitalMinute, lblDigitalSecond;
@synthesize lblDigitalHourBackground, lblDigitalMinuteBackground, lblDigitalSecondBackground;
@synthesize lblDigitalColon, lblDigitalMorning, lblDigitalSlash;
@synthesize lblDigitalMonth, lblDigitalDay, lblDigitalWeekday;
@synthesize lblDigitalMonthCaption, lblDigitalDayCaption, lblDigitalWeekdayCaption;

//Grand Clock
@synthesize imgGrandHour, imgGrandMinute, imgGrandSecond, imgGrandBackground, imgGrandClock, imgGrandSecondCover;
@synthesize lblGrandDay, lblGrandWeekday;


//Polar Clock
@synthesize vwPolarClockContainer, imgPolarHour, imgPolarMinute, imgPolarSecond, imgPolarWeekday, imgPolarDay;
@synthesize vwPolarHour, vwPolarMinute, vwPolarSecond, vwPolarWeekday, vwPolarDay;
@synthesize lblPolarMonth, lblPolarDay1, lblPolarDay2, lblPolarWeekday, lblPolarHour1, lblPolarHour2;
@synthesize lblPolarMinute1, lblPolarMinute2, lblPolarSecond1, lblPolarSecond2;


//Word Clock
@synthesize imgWordBackground, imgWordClockBackground, imgWordFinanceBar;
@synthesize lblWordHour, lblWordMinute, lblWordSecond, lblWordMorning;
@synthesize lblWordYear, lblWordMonth, lblWordDay, lblWordWeekday;
@synthesize lblWordHourCaption, lblWordMinuteCaption, lblWordSecondCaption;
@synthesize tailViewList;
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.

#pragma mark -
#pragma mark Initialization


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    
	[[WeatherAgent sharedWeatherAgent] setDelegate:self];
	[[StockAgent sharedStockAgent] setDelegate:self];
	[[CurrencyAgent sharedCurrencyAgent] setDelegate:self];
	curClockIndex = 0;
	cyberClockColor = 0;
	digitalClockColor = 0;
	grandClockColor = 0;
	polarClockColor = 0;
	wordClockColor = 0;
  
    //G.W.
//	scrollView.delegate = self;
//	scrollView.showsHorizontalScrollIndicator = NO;
//	scrollView.showsVerticalScrollIndicator = NO;
	
	
	
	arrayValue = [[NSMutableArray alloc] initWithCapacity:7];
	[arrayValue addObject:@"Sun"];
	[arrayValue addObject:@"Mon"];
	[arrayValue addObject:@"Tue"];
	[arrayValue addObject:@"Wed"];
	[arrayValue addObject:@"Thu"];
	[arrayValue addObject:@"Fri"];
	[arrayValue addObject:@"Sat"];
	
	[CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
	[self setCyberClock];
	[self setPolarClock];
	[self setGrandClock];

	[CATransaction commit];		
	[self setDigitClock];
	[self setWordClock];
	
	
	
	
	[self setCyberClockColor:0];
	[self setGrandClockColor:0];
	[self setDigitalClockColor:0];
	[self setPolarClockColor:0];
	[self setWordClockColor:0];
	
	
	
	
	self.lblWeather.alpha = 0.0;
	self.imgWeather.alpha = 0.0;
	self.lblRate.alpha = 0.0;
	self.lblValue.alpha = 0.0;
	self.lblPercent.alpha = 0.0;
    //G.W.
    self.scrollView.touchDelegate = self;
    bShowedButton = NO;
    bShowing = NO;

    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    [self adjustClockLayoutWithOrientation:orientation];
}

#pragma mark Setting Clocks



- (void) setCyberClock {
	//Cyber Clock
	CGRect secondframe = [imgCyberSecond frame];
	imgCyberSecond.layer.anchorPoint = CGPointMake(0.5, 1);
	imgCyberSecond.layer.position = CGPointMake(secondframe.origin.x + 0.5*secondframe.size.width, secondframe.origin.y + secondframe.size.height);
	CGRect minuteframe = [imgCyberMinute frame];
	imgCyberMinute.layer.anchorPoint = CGPointMake(0.5, 1);
	imgCyberMinute.layer.position = CGPointMake(minuteframe.origin.x + 0.5*minuteframe.size.width, minuteframe.origin.y + minuteframe.size.height);
	
	CGRect hourframe = [imgCyberMinute frame];
	imgCyberHour.layer.anchorPoint = CGPointMake(0.5, 1);
	imgCyberHour.layer.position = CGPointMake(hourframe.origin.x + 0.5*hourframe.size.width, hourframe.origin.y + hourframe.size.height);

}
- (void) setGrandClock {
	//Grand Clock
	CGRect frameRect = [imgGrandHour frame];
	imgGrandHour.layer.anchorPoint = CGPointMake(0.5, 64.0/70.0);
	imgGrandHour.layer.position = CGPointMake(frameRect.origin.x + 0.5*frameRect.size.width, frameRect.origin.y + 64.0/70.0*frameRect.size.height);
	
	frameRect = [imgGrandMinute frame];
	imgGrandMinute.layer.anchorPoint = CGPointMake(0.5, 87.0/93.0);
	imgGrandMinute.layer.position = CGPointMake(frameRect.origin.x + 0.5*frameRect.size.width, frameRect.origin.y + 87.0/93.0*frameRect.size.height);
	
	frameRect = [imgGrandSecond frame];
	imgGrandSecond.layer.anchorPoint = CGPointMake(0.5, 103.0/123.0);
	imgGrandSecond.layer.position = CGPointMake(frameRect.origin.x + 0.5*frameRect.size.width, frameRect.origin.y + 103.0/123.0*frameRect.size.height);

	
}
- (void) setPolarClock {
	//Grand Clock
	CGRect frameRect = [imgPolarHour frame];
	imgPolarHour.layer.anchorPoint = CGPointMake(0.5, 0.5);
	imgPolarHour.layer.position = CGPointMake(frameRect.origin.x + 0.5*frameRect.size.width, frameRect.origin.y + 0.5*frameRect.size.height);
	
	frameRect = [imgPolarMinute frame];
	imgPolarMinute.layer.anchorPoint = CGPointMake(0.5, 0.5);
	imgPolarMinute.layer.position = CGPointMake(frameRect.origin.x + 0.5*frameRect.size.width, frameRect.origin.y + 0.5*frameRect.size.height);
	
	frameRect = [imgPolarDay frame];
	imgPolarDay.layer.anchorPoint = CGPointMake(0.5, 0.5);
	imgPolarDay.layer.position = CGPointMake(frameRect.origin.x + 0.5*frameRect.size.width, frameRect.origin.y + 0.5*frameRect.size.height);
	
	frameRect = [imgPolarWeekday frame];
	imgPolarWeekday.layer.anchorPoint = CGPointMake(0.5, 0.5);
	imgPolarWeekday.layer.position = CGPointMake(frameRect.origin.x + 0.5*frameRect.size.width, frameRect.origin.y + 0.5*frameRect.size.height);
	
	frameRect = [vwPolarDay frame];
	vwPolarDay.layer.anchorPoint = CGPointMake(0.5, 0.5);
	vwPolarDay.layer.position = CGPointMake(frameRect.origin.x + 0.5*frameRect.size.width, frameRect.origin.y + 0.5*frameRect.size.height);
	
	frameRect = [vwPolarWeekday frame];
	vwPolarWeekday.layer.anchorPoint = CGPointMake(0.5, 0.5);
	vwPolarWeekday.layer.position = CGPointMake(frameRect.origin.x + 0.5*frameRect.size.width, frameRect.origin.y + 0.5*frameRect.size.height);
	
	frameRect = [vwPolarHour frame];
	vwPolarHour.layer.anchorPoint = CGPointMake(0.5, 0.5);
	vwPolarHour.layer.position = CGPointMake(frameRect.origin.x + 0.5*frameRect.size.width, frameRect.origin.y + 0.5*frameRect.size.height);
	
	frameRect = [vwPolarMinute frame];
	vwPolarMinute.layer.anchorPoint = CGPointMake(0.5, 0.5);
	vwPolarMinute.layer.position = CGPointMake(frameRect.origin.x + 0.5*frameRect.size.width, frameRect.origin.y + 0.5*frameRect.size.height);
	
	frameRect = [vwPolarSecond frame];
	vwPolarSecond.layer.anchorPoint = CGPointMake(0.5, 0.5);
	vwPolarSecond.layer.position = CGPointMake(frameRect.origin.x + 0.5*frameRect.size.width, frameRect.origin.y + 0.5*frameRect.size.height);
    
    //Creating TailView
    //Creating tail
    self.tailViewList = [NSMutableArray array];
	for (int i = 0; i < 60; i++)
	{
		UIView* tailView = [[[UIView alloc] initWithFrame:CGRectMake(112, 13, 95, 294)] autorelease];
        
		UILabel *newLabel = [[[UILabel alloc]initWithFrame:CGRectMake(23, 0, 27, 21)] autorelease];
		newLabel.text = [NSString stringWithFormat:@"%02d", i];

		newLabel.textAlignment = UITextAlignmentRight;
		[tailView addSubview:newLabel];
		
		tailView.backgroundColor = [UIColor clearColor];
		newLabel.backgroundColor = [UIColor clearColor];
		newLabel.textColor = [UIColor whiteColor];
		newLabel.alpha = 0.5;
		
		tailView.layer.anchorPoint = CGPointMake(0.5, 0.5);
		tailView.layer.position = CGPointMake(frameRect.origin.x + 0.5*frameRect.size.width, frameRect.origin.y + 0.5*frameRect.size.height);
		tailView.frame = vwPolarSecond.frame;
		
        tailView.transform = CGAffineTransformMakeRotation(DEGREES_TO_RANDIANS(i*6.0));
		
		[vwPolarClockContainer addSubview:tailView];
		
		[tailViewList addObject:tailView];

	}

    [vwPolarClockContainer bringSubviewToFront:vwPolarSecond];
}

- (void) setDigitClock {
	[lblDigitalHour setFont:[UIFont fontWithName:@"DS-Digital" size:84.0]];
	
	[lblDigitalHourBackground setFont:[UIFont fontWithName:@"DS-Digital" size:84.0]];
	lblDigitalHourBackground.alpha = 0.1;
	[lblDigitalMinute setFont:[UIFont fontWithName:@"DS-Digital" size:84.0]];
	
	
	[lblDigitalMinuteBackground setFont:[UIFont fontWithName:@"DS-Digital" size:84.0]];
	lblDigitalMinuteBackground.alpha = 0.1;
	
	[lblDigitalSecond setFont:[UIFont fontWithName:@"DS-Digital" size:48]];
	lblDigitalSecond.text = @"36";
	
	[lblDigitalSecondBackground setFont:[UIFont fontWithName:@"DS-Digital" size:48]];
	lblDigitalSecondBackground.alpha = 0.1;
	[lblDigitalWeekday setFont:[UIFont fontWithName:@"DS-Digital" size:30.0]];
	[lblDigitalMonth setFont:[UIFont fontWithName:@"DS-Digital" size:30.0]];
	[lblDigitalDay setFont:[UIFont fontWithName:@"DS-Digital" size:30.0]];
	[lblDigitalColon setFont:[UIFont fontWithName:@"DS-Digital" size:84.0]];
	[lblDigitalSlash setFont:[UIFont fontWithName:@"DS-Digital" size:30.0]];
	[lblDigitalMorning setFont:[UIFont fontWithName:@"DS-Digital" size:18.0]];
}

- (void) setWordClock {
	[lblWordHour setFont:[UIFont fontWithName:@"AEnigmaScrawl4BRK" size:40]];
	[lblWordMinute setFont:[UIFont fontWithName:@"AEnigmaScrawl4BRK" size:40]];
	[lblWordSecond setFont:[UIFont fontWithName:@"AEnigmaScrawl4BRK" size:40]];
	
	[lblWordSecondCaption setFont:[UIFont fontWithName:@"AEnigmaScrawl4BRK" size:24]];
	[lblWordMinuteCaption setFont:[UIFont fontWithName:@"AEnigmaScrawl4BRK" size:24]];
	[lblWordHourCaption setFont:[UIFont fontWithName:@"AEnigmaScrawl4BRK" size:24]];
	[lblWordMorning setFont:[UIFont fontWithName:@"AEnigmaScrawl4BRK" size:24]];
	
	[lblWordYear setFont:[UIFont fontWithName:@"AEnigmaScrawl4BRK" size:24]];
	[lblWordMonth setFont:[UIFont fontWithName:@"AEnigmaScrawl4BRK" size:24]];
	[lblWordDay setFont:[UIFont fontWithName:@"AEnigmaScrawl4BRK" size:24]];
	[lblWordWeekday setFont:[UIFont fontWithName:@"AEnigmaScrawl4BRK" size:24]];
	
	
}

#pragma mark Set Colors of Clocks
- (void) setDigitalClockColor:(int)colorIndex {
	UIColor *color;
	if (colorIndex == 0)
        color = [UIColor colorWithRed:0 green:1.0 blue:0 alpha:1.0];
	else if (colorIndex == 1)
		color = [UIColor colorWithRed:0 green:0.7 blue:1.0 alpha:1.0];
	else
		color = [UIColor colorWithRed:1 green:0 blue:0.7 alpha:1.0];
//    color = [UIColor colorWithRed:0 green:1.0 blue:0 alpha:1.0];
    
	lblDigitalHour.textColor = color;
	lblDigitalHourBackground.textColor = color;
	lblDigitalMinute.textColor = color;
	lblDigitalMinuteBackground.textColor = color;	
	lblDigitalSecond.textColor = color;	
	lblDigitalSecondBackground.textColor = color;
	lblDigitalWeekday.textColor = color;
	lblDigitalMonth.textColor = color;
	lblDigitalDay.textColor = color;
	lblDigitalMonthCaption.textColor = color;;
	lblDigitalDayCaption.textColor = color;
	lblDigitalWeekdayCaption.textColor = color;
	lblDigitalColon.textColor = color;
	lblDigitalSlash.textColor = color;
	lblDigitalMorning.textColor = color;
//	imgDigitalBackground.image = [UIImage imageNamed:[NSString stringWithFormat:@"digital_BG_c0%d.png", colorIndex]];
//   	imgDigitalBackground.image = [UIImage imageNamed:[NSString stringWithFormat:@"gold_summit.png", colorIndex]];
	
}
- (void) setCyberClockColor:(int)colorIndex {
	imgCyberClock.image = [UIImage imageNamed:[NSString stringWithFormat:@"cyber clock_BG_c0%d.png", colorIndex]];
	imgCyberHourCover.image = [UIImage imageNamed:[NSString stringWithFormat:@"cyber_hour_cover_c0%d.png", colorIndex]];
	imgCyberHour.image = [UIImage imageNamed:[NSString stringWithFormat:@"cyber_hour_c0%d.png", colorIndex]];
	imgCyberMinute.image = [UIImage imageNamed:[NSString stringWithFormat:@"cyber_minute_c0%d.png", colorIndex]];
	imgCyberSecond.image = [UIImage imageNamed:[NSString stringWithFormat:@"cyber_second_c0%d.png", colorIndex]];
}
- (void) setGrandClockColor:(int)colorIndex {
	imgGrandClock.image = [UIImage imageNamed:[NSString stringWithFormat:@"grand_clock_c0%d.png", colorIndex]];
}
- (void) setPolarClockColor:(int)colorIndex {
	imgPolarHour.image = [UIImage imageNamed:[NSString stringWithFormat:@"polar_hour_c0%d.png", colorIndex]];
	imgPolarMinute.image = [UIImage imageNamed:[NSString stringWithFormat:@"polar_minute_c0%d.png", colorIndex]];
	imgPolarSecond.image = [UIImage imageNamed:[NSString stringWithFormat:@"polar_second_c0%d.png", colorIndex]];
	imgPolarDay.image = [UIImage imageNamed:[NSString stringWithFormat:@"polar_date_c0%d.png", colorIndex]];
	imgPolarWeekday.image = [UIImage imageNamed:[NSString stringWithFormat:@"polar_day_c0%d.png", colorIndex]];	
	
	//Labels
	
	float colors[3][5][3] = {
		{
			{255, 170, 0},		//Second
			{95, 243, 0},		//Minute
			{1, 214, 254},		//Hour
			{139, 59, 255},		//Weekday
			{255, 0, 0}			//Day
		},
		{
			{1, 253, 170}, 
			{0, 110, 251},
			{255, 0, 215},
			{254, 124, 53},
			{0, 255, 0}
		}, 
		{
			{255, 0, 0},
			{243, 202, 0},
			{0, 255, 115},
			{58, 139, 254},
			{255, 0, 115}
		}
	};
	lblPolarSecond1.textColor = [UIColor colorWithRed:colors[colorIndex][0][0]/255.0 green:colors[colorIndex][0][1]/255.0 blue:colors[colorIndex][0][2]/255.0 alpha:1.0];
	lblPolarSecond2.textColor = [UIColor colorWithRed:colors[colorIndex][0][0]/255.0 green:colors[colorIndex][0][1]/255.0 blue:colors[colorIndex][0][2]/255.0 alpha:1.0];
	lblPolarMinute1.textColor = [UIColor colorWithRed:colors[colorIndex][1][0]/255.0 green:colors[colorIndex][1][1]/255.0 blue:colors[colorIndex][1][2]/255.0 alpha:1.0];
	lblPolarMinute2.textColor = [UIColor colorWithRed:colors[colorIndex][1][0]/255.0 green:colors[colorIndex][1][1]/255.0 blue:colors[colorIndex][1][2]/255.0 alpha:1.0];
	lblPolarHour1.textColor = [UIColor colorWithRed:colors[colorIndex][2][0]/255.0 green:colors[colorIndex][2][1]/255.0 blue:colors[colorIndex][2][2]/255.0 alpha:1.0];
	lblPolarHour2.textColor = [UIColor colorWithRed:colors[colorIndex][2][0]/255.0 green:colors[colorIndex][2][1]/255.0 blue:colors[colorIndex][2][2]/255.0 alpha:1.0];
	lblPolarWeekday.textColor = [UIColor colorWithRed:colors[colorIndex][3][0]/255.0 green:colors[colorIndex][3][1]/255.0 blue:colors[colorIndex][3][2]/255.0 alpha:1.0];
	lblPolarDay1.textColor = [UIColor colorWithRed:colors[colorIndex][4][0]/255.0 green:colors[colorIndex][4][1]/255.0 blue:colors[colorIndex][4][2]/255.0 alpha:1.0];
	lblPolarDay2.textColor = [UIColor colorWithRed:colors[colorIndex][4][0]/255.0 green:colors[colorIndex][4][1]/255.0 blue:colors[colorIndex][4][2]/255.0 alpha:1.0];
	lblPolarMonth.textColor = [UIColor colorWithRed:colors[colorIndex][4][0]/255.0 green:colors[colorIndex][4][1]/255.0 blue:colors[colorIndex][4][2]/255.0 alpha:1.0];
    
    // PolarTail
    for (int i = 0; i <  60; i++)
    {
        UIView *tailView = [tailViewList objectAtIndex:(i)];
        UITextView *textView = [[tailView subviews] objectAtIndex:0];
        textView.textColor = lblPolarSecond1.textColor;
        
    }
	
}
- (void) setWordClockColor:(int)colorIndex {
	UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
	if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight)
	{
		if (colorIndex > 0)
			imgWordClockBackground.image = [UIImage imageNamed:[NSString stringWithFormat:@"word_clock_c0%d.png", colorIndex]];
		else
			imgWordClockBackground.image = nil;
	}
	else
	{
	
		if (colorIndex > 0)
			imgWordClockBackground.image = [UIImage imageNamed:[NSString stringWithFormat:@"word_clock_p_c0%d.png", colorIndex]];
		else
			imgWordClockBackground.image = nil;
	}
	

}
#pragma mark -
#pragma mark Setting Options


#pragma mark Setting Alarms

- (void)viewDidDisappear:(BOOL)animated {
    bShowing = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
	[self doAlarm];
    [Database logAllNotifications:@"All Notifications"];
}

- (void)viewWillAppear:(BOOL)animated {
    
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents* now = [calendar components:(NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit) fromDate:[NSDate date]];
	NSInteger hour = [now hour];
	NSInteger minute = [now minute];
	NSInteger second = [now second];
	NSInteger day = [now day];
	NSInteger year = [now year];
	NSInteger month = [now month];
	NSInteger weekday = [now weekday];
	[calendar release];	
    bShowing = YES;
    [self timeChanged:hour Min:minute Sec:second animated:NO];
	[self dateChanged:year month:month day:day weekday:weekday animated:NO];
    
    DisplayInfo *dspInfo = [[[DisplayInfo alloc] init] autorelease];
	[Database getDisplayInfo:dspInfo];
	self.displayInfo = dspInfo;
	[self applyDisplayInfo];
	
    
	if ([CurrencyAgent sharedCurrencyAgent].loadedCurrencyItem != nil)
		[self didChangeCurrency:[CurrencyAgent sharedCurrencyAgent].loadedCurrencyItem];
	[self didChangeStock];
	UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    [self willAnimateRotationToInterfaceOrientation:orientation duration:0];
    [self moveAndShowButtons:curClockIndex];
}

- (void) applyDisplayInfo {

	
	imgMask.alpha = (50.0-displayInfo.bright)/100.0;
	//Show Second
	imgCyberSecond.hidden = !displayInfo.show_second;
	lblDigitalSecond.hidden = !displayInfo.show_second;
	imgGrandSecond.hidden = !displayInfo.show_second;
	imgCyberSecond.hidden = !displayInfo.show_second;
	imgPolarSecond.hidden = !displayInfo.show_second;
	vwPolarSecond.hidden = !displayInfo.show_second;
	lblWordSecond.hidden = !displayInfo.show_second;
	lblWordSecondCaption.hidden = !displayInfo.show_second;
	//Polar tail
    for (int i = 0; i <  60; i++)
    {
        UIView *tailView = [tailViewList objectAtIndex:(i)];
        tailView.hidden = !displayInfo.show_second;
        
    }
	//Show Day
	lblCyberDay.hidden = !displayInfo.show_day;
	lblCyberWeekday.hidden = !displayInfo.show_day;
	lblDigitalMonth.hidden = !displayInfo.show_day;
	lblDigitalDay.hidden = !displayInfo.show_day;
	lblDigitalWeekday.hidden = !displayInfo.show_day;
	lblDigitalMonthCaption.hidden = !displayInfo.show_day;
	lblDigitalDayCaption.hidden = !displayInfo.show_day;
	lblDigitalWeekdayCaption.hidden = !displayInfo.show_day;
	lblDigitalSlash.hidden = !displayInfo.show_second;
    
	
	lblGrandDay.hidden = !displayInfo.show_day;
	lblGrandWeekday.hidden = !displayInfo.show_day;
	
	lblPolarMonth.hidden = !displayInfo.show_day;
	vwPolarDay.hidden = !displayInfo.show_day;
	imgPolarDay.hidden = !displayInfo.show_day;
	imgPolarWeekday.hidden = !displayInfo.show_day;
	vwPolarWeekday.hidden = !displayInfo.show_day;
	lblWordDay.hidden = !displayInfo.show_day;
	lblWordYear.hidden = !displayInfo.show_day;
	lblWordMonth.hidden = !displayInfo.show_day;
	lblWordWeekday.hidden = !displayInfo.show_day;
	
	
	lblWeather.hidden = !displayInfo.show_weather;
	imgWeather.hidden = !displayInfo.show_weather;
	lblTempH.hidden = !displayInfo.show_weather;
	lblTempL.hidden = !displayInfo.show_weather;
	imgThermoIcon.hidden = !displayInfo.show_weather;
	lblAlarm.hidden = !displayInfo.show_next_alarm;
	
	
	NSLog(@"Display Info second:%d, weather_%d, next_alarm%d", displayInfo.show_second, displayInfo.show_weather, displayInfo.show_next_alarm);
	timeFormat =displayInfo.time_format;
	temperatureUnit = displayInfo.temp_unit;
	distanceUnit = displayInfo.dist_unit;
    
    
    if (timeFormat)
    {
        lblDigitalMorning.hidden = YES;
        lblWordMorning.hidden = YES;
    }
    else
    {
        lblDigitalMorning.hidden = NO;
        lblWordMorning.hidden = NO;
    }
}
- (void) doAlarm
{
	NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents* now = [calendar components:(NSHourCalendarUnit|NSMinuteCalendarUnit|NSWeekdayCalendarUnit) fromDate:[NSDate date]];
	NSInteger hour = [now hour];
	NSInteger minute = [now minute];
	NSInteger week = [now weekday]-1;
	
	AlarmInfo *nextAlarmInfo = nil;
	int i;
	for (i = week; i < week + 7; i++)
	{
		int bestHour = 24;
		int bestMin = 60;
		for (AlarmInfo* alarmInfo in alarmArray) {
            if (alarmInfo.enable == 0)
                continue;
			NSArray* arr = [alarmInfo.repeat componentsSeparatedByString:@" "];
			int containingWeekday = 0;
			if([alarmInfo.repeat isEqualToString:@"Every Day"])
				containingWeekday = 1;
            else if([alarmInfo.repeat isEqualToString:@"Never"])
                containingWeekday = 1;
			else 
			{
				for (NSString *item in arr) {
                    NSLog(@"%@ %@", [arrayValue objectAtIndex:i%7], item);
					if ([item isEqualToString:@"EveryDay"]|| [[arrayValue objectAtIndex:i%7] isEqualToString:item]) {
						containingWeekday = 1;
						break;
					}
				}
			}

			
			if (containingWeekday == 1)
			{
				int compHour = alarmInfo.hour;
				int compMin = alarmInfo.minute;
				if (alarmInfo.hour == 12 && alarmInfo.am == 1)
					compHour = 24;
				
				if (((compHour > hour || (compHour == hour && compMin > minute)) || i > week)  && bestHour >= compHour) {
					if (bestHour == compHour && bestMin <= compMin)
						continue;
					bestHour = compHour;
					bestMin = compMin;
					nextAlarmInfo = alarmInfo;
					
				}
			}
		}
		if (nextAlarmInfo != nil)
			break;
	}
	NSString *alarmString = @"";
	if (nextAlarmInfo != nil)
	{
		NSString *dayString;
		if (i == week)
			dayString = @"Today";
		else if (i == week + 1)
			dayString = @"Tomorrow";
		else {
			dayString = [NSString stringWithFormat:@"%@", [arrayValue objectAtIndex:i%7]];
		}
		
		curAlarmInfo = nextAlarmInfo;
		if (timeFormat)
			alarmString = [NSString stringWithFormat:@"%@ %02d:%02d",dayString, curAlarmInfo.hour, curAlarmInfo.minute];
		else
			alarmString = [NSString stringWithFormat:@"%@ %02d:%02d:%@",dayString, curAlarmInfo.hour % 12, curAlarmInfo.minute, (curAlarmInfo.am?@"PM":@"AM")];
	}
	lblAlarm.text = alarmString;
}
#pragma mark -
#pragma mark Time and Date Change
- (void) timeChanged:(int)hour Min:(int)minute Sec:(int)second animated:(BOOL)animated{
    if (!bShowing)
        return;
	if (animated == YES) {
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:1];
		[UIView setAnimationCurve:UIViewAnimationCurveLinear];
		[UIView setAnimationBeginsFromCurrentState:YES];
	}
	// Cyber Clock
	imgCyberSecond.transform = CGAffineTransformMakeRotation(DEGREES_TO_RANDIANS(second*6.0));
	imgCyberMinute.transform = CGAffineTransformMakeRotation(DEGREES_TO_RANDIANS((minute+second/60.0)*6.0));
	imgCyberHour.transform = CGAffineTransformMakeRotation(DEGREES_TO_RANDIANS((hour%12 + minute/60.0)*30.0));
	
	// Grand Clock
	imgGrandSecond.transform = CGAffineTransformMakeRotation(DEGREES_TO_RANDIANS(second*6.0));
	imgGrandMinute.transform = CGAffineTransformMakeRotation(DEGREES_TO_RANDIANS((minute+second/60.0)*6.0));
	imgGrandHour.transform = CGAffineTransformMakeRotation(DEGREES_TO_RANDIANS((hour%12 + minute/60.0)*30.0));
	
	// Polar Clock
    
    imgPolarSecond.transform = CGAffineTransformMakeRotation(DEGREES_TO_RANDIANS(((second*6.0) + 8.0)));
    imgPolarMinute.transform = CGAffineTransformMakeRotation(DEGREES_TO_RANDIANS((minute+second/60.0)*6.0));
    imgPolarHour.transform = CGAffineTransformMakeRotation(DEGREES_TO_RANDIANS((hour%12 + minute/60.0)*30.0));
    vwPolarMinute.transform = CGAffineTransformMakeRotation(DEGREES_TO_RANDIANS(((minute+second/60.0)*6.0 - 8.0)));
    vwPolarHour.transform = CGAffineTransformMakeRotation(DEGREES_TO_RANDIANS(((hour%12 + minute/60.0)*30.0 - 15.0)));
    lblPolarHour1.text = [NSString stringWithFormat:@"%d", (timeFormat?hour:hour%12)];
    lblPolarHour2.text = (hour < 12)? @"AM" : @"PM";
    lblPolarMinute1.text = [NSString stringWithFormat:@"%d", minute];
    
    //Tail views
    
	for (int i = second + 1; i < second + 60; i++)
    {
        UIView *tailView = [tailViewList objectAtIndex:(i%60)];
        float tailAlpha = 0.0;
        int distance = second + 60 - i;
        if (distance < 50)
        {
            tailAlpha =(50.0 - (float)distance)/50.0;
        }
        
        tailView.alpha = tailAlpha;
    }
    
	// End tail
	if (animated == YES)
		[UIView commitAnimations];
    // Polar Clock Second
    UIView *tailView = [tailViewList objectAtIndex:(second)];
    tailView.alpha = 1;
     
	vwPolarSecond.transform = CGAffineTransformMakeRotation(DEGREES_TO_RANDIANS(second*6.0));
	NSString *secondString;
	if (second < 10)
		secondString = [NSString stringWithFormat:@"0%d", second];
	else
		secondString = [NSString stringWithFormat:@"%d", second];

	lblPolarSecond1.text = secondString;    
    
	// Digital Clock
	lblDigitalHour.text = [self digitString:(timeFormat?hour:hour%12)];
	
	lblDigitalMinute.text = [self digitString:minute];
	lblDigitalSecond.text = [self digitString:second];
	lblDigitalMorning.text = (hour < 12)? @"AM" : @"PM";
	
	//Word Clock
	lblWordHour.text = [NSString stringWithFormat:@"%d", (timeFormat?hour:hour%12)];
	lblWordMinute.text = [NSString stringWithFormat:@"%d", minute];
	lblWordSecond.text = [NSString stringWithFormat:@"%d", second];
	lblWordMorning.text = (hour < 12)? @"am":@"pm";
	
    if (minute == 50 && second == 0)
    {
        [[WeatherAgent sharedWeatherAgent] requestWeatherWithWoeID:advancedInfo.location_woeid andUnit:self.displayInfo.dist_unit];
        [[StockAgent sharedStockAgent] requestStock];
        [[CurrencyAgent sharedCurrencyAgent] requestCurrency];
    }

}

- (void)removePolarSecondTail:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {	
	UIView *secondView = context;
    if (secondView != nil)
        [secondView removeFromSuperview];
}
- (void) dateChanged:(int)year month:(int)month day:(int)day weekday:(int)weekday animated:(BOOL)animated{
	if (!bShowing)
        return;
	
	//Polar Clock
	NSArray *monthNames = [NSArray arrayWithObjects:@"Jan", @"Feb", @"Mar", @"Apr", @"May", @"Jun", @"Jul", @"Aug", @"Sep", @"Oct", @"Nov", @"Dec", nil];
	static float dayofMonths[12] = {31.0, 28.0, 31.0, 30.0, 31.0, 30.0, 31.0, 31.0, 30.0, 31.0, 30.0, 31.0}; 
	imgPolarDay.transform = CGAffineTransformMakeRotation(DEGREES_TO_RANDIANS(360.0 * (float)day / dayofMonths[month-1]));
	imgPolarWeekday.transform = CGAffineTransformMakeRotation(DEGREES_TO_RANDIANS(360.0 * weekday / 7));
	vwPolarDay.transform = CGAffineTransformMakeRotation(DEGREES_TO_RANDIANS((360.0 * (float)day / dayofMonths[month-1] - 20.0)));
	vwPolarWeekday.transform = CGAffineTransformMakeRotation(DEGREES_TO_RANDIANS((360.0 * weekday / 7 - 20.0)));
	lblPolarDay1.text = [NSString stringWithFormat:@"%d", day];
	if (day == 1)
		lblPolarDay2.text = @"st";
	else if (day == 2)
		lblPolarDay2.text = @"nd";
	else if (day == 3)
		lblPolarDay2.text = @"rd";
	else 
		lblPolarDay2.text = @"th";

	lblPolarWeekday.text = [arrayValue objectAtIndex:weekday - 1];
	lblPolarMonth.text = [monthNames objectAtIndex:month - 1];
	//CyberClock
	lblCyberDay.text = [NSString stringWithFormat:@"%d/%d", month, day];
	lblCyberWeekday.text = [[arrayValue objectAtIndex:weekday - 1] uppercaseString];
	
	//Grand Clock
	lblGrandDay.text = [NSString stringWithFormat:@"%d", day];
	lblGrandWeekday.text = [[arrayValue objectAtIndex:weekday - 1] uppercaseString];
	//Digital Clock
	lblDigitalMonth.text = [self digitString:month] ;	
	lblDigitalDay.text = [self digitString:day];
	lblDigitalWeekday.text = [arrayValue objectAtIndex:weekday - 1];
	
	//Word Clock
	lblWordYear.text = [NSString stringWithFormat:@"%d/", year];
	lblWordMonth.text = [NSString stringWithFormat:@"%d/", month];
	lblWordDay.text =[NSString stringWithFormat:@"%d,", day];
	lblWordWeekday.text = [arrayValue objectAtIndex:weekday - 1];
	[[WeatherAgent sharedWeatherAgent] requestWeatherWithWoeID:advancedInfo.location_woeid andUnit:self.displayInfo.dist_unit];
	[[StockAgent sharedStockAgent] requestStock];
	[[CurrencyAgent sharedCurrencyAgent] requestCurrency];
	
}

- (NSString *)digitString:(int)number {
	if (number % 10 == 1)
		return [NSString stringWithFormat:@"%d 1", (number/10)];
	return [NSString stringWithFormat:@"%02d", number];

}



#pragma mark -
#pragma mark Actions of pressing buttons

- (IBAction) settingAction:(id)sender
{
	SettingViewController* setting = [[[SettingViewController alloc] init] autorelease]; 
	UINavigationController* naviController = [[[UINavigationController alloc] initWithRootViewController:setting] autorelease];
    naviController.navigationBar.tintColor = [UIColor colorWithRed:0.2 green:0.5 blue:0.8 alpha:0.5];
	[naviController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self presentModalViewController:naviController animated:YES];
}

- (IBAction) infoAction:(id)sender
{
	
//	InfoMainController *controller = [[[InfoMainController alloc] initWithNibName:@"InfoMainController" bundle:nil] autorelease];
//    [self presentModalViewController:controller animated:YES];

    infoceViewController *infoView = [[[infoceViewController alloc] init] autorelease];
    UINavigationController *naviInfo = [[[UINavigationController alloc] initWithRootViewController:infoView] autorelease];
    naviInfo.navigationBar.tintColor = [UIColor colorWithRed:0.2 green:0.5 blue:0.8 alpha:0.5];
    [naviInfo setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self presentModalViewController:naviInfo animated:YES];
}

- (IBAction) alarmAction:(id)sender
{
	int alarmIndex;
	for (alarmIndex = 0; alarmIndex < [alarmArray count]; alarmIndex ++)
	{
		AlarmInfo *alarmInfo = [alarmArray objectAtIndex:alarmIndex];
		if ([curAlarmInfo.id_value isEqualToString:alarmInfo.id_value])
			 break;
	}
	if (alarmIndex >= [alarmArray count])
		return;
	
	SettingViewController* setting = [[[SettingViewController alloc] init] autorelease]; 
	UINavigationController* naviController = [[[UINavigationController alloc] initWithRootViewController:setting] autorelease];
    naviController.navigationBar.tintColor = [UIColor blackColor];
	
	AlarmlistViewController* alarmlist = [[[AlarmlistViewController alloc] init] autorelease];
	[naviController pushViewController:alarmlist animated:NO];
	
	AlarmViewController* alarm = [[[AlarmViewController alloc] init] autorelease];
	alarm.nSelectAlarm = alarmIndex;
	[naviController pushViewController:alarm animated:NO];
	
	[naviController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
	
    [self presentModalViewController:naviController animated:YES];
}

- (IBAction) colorAction:(id)sender
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationBeginsFromCurrentState:YES];
	//Cyber Clock
	if (curClockIndex == 0)
	{
		cyberClockColor = (cyberClockColor + 1)  % 3;
		[self setCyberClockColor:cyberClockColor];
	}
	//Digital Clock
	if (curClockIndex == 1)
	{
		digitalClockColor = (digitalClockColor + 1)  % 3;
		[self setDigitalClockColor:digitalClockColor];
	}
	//Grand Clock
	if (curClockIndex == 2)
	{
		grandClockColor = (grandClockColor + 1)  % 3;
		[self setGrandClockColor:grandClockColor];
	}
	//Polar
	if (curClockIndex == 3)
	{
		polarClockColor = (polarClockColor + 1)  % 3;
		[self setPolarClockColor:polarClockColor];
	}
    
    
	//Word Clock
	if (curClockIndex == 4)
	{
		wordClockColor = (wordClockColor + 1)  % 3;
		[self setWordClockColor:wordClockColor];
	}

	[UIView commitAnimations];
	
}

- (IBAction) sleepAction:(id)sender
{
	SettingViewController* setting = [[[SettingViewController alloc] init] autorelease]; 
	UINavigationController* naviController = [[[UINavigationController alloc] initWithRootViewController:setting] autorelease];
    naviController.navigationBar.tintColor = [UIColor blackColor];
	
	SleepViewController *sleep = [[[SleepViewController alloc] init] autorelease];
	[naviController pushViewController:sleep animated:NO];
	[naviController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
	
    [self presentModalViewController:naviController animated:YES];
}

- (IBAction) financeAction:(id)sender
{
    /*
	SettingViewController* setting = [[[SettingViewController alloc] init] autorelease]; 
	UINavigationController* naviController = [[[UINavigationController alloc] initWithRootViewController:setting] autorelease];
    naviController.navigationBar.tintColor = [UIColor blackColor];
	
	AdvancedViewController *advanced = [[[AdvancedViewController alloc] init] autorelease];
	[naviController pushViewController:advanced animated:NO];

    StockMarketSelectController *stock = [[[StockMarketSelectController alloc] init] autorelease];
    [naviController pushViewController:stock animated:NO];
	[naviController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];	
    [self presentModalViewController:naviController animated:YES];
     */
    
	NSString *symbol = [[StockAgent sharedStockAgent] nextStockSymbol:advancedInfo.stockSymbol];
    advancedInfo.stockSymbol = symbol;
	[Database updateAdvancedInfo];
    [self didChangeStock];
	
}



#pragma mark -
#pragma mark Rotation
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    //return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
	return YES;
}

-(BOOL)shouldAutorotate
{
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void) adjustClockLayoutWithOrientation:(UIInterfaceOrientation)orientation
{
    orientation = [[UIApplication sharedApplication] statusBarOrientation];
    int offsetPage = ((2 - curClockIndex) + 5) % 5;
    UIView *views[] = {self.vwCyberView, self.vwDigitalView, self.vwGrandView, self.vwPolarView, self.vwWordView};
    int pageWidth, pageHeight;
    if ((orientation == UIInterfaceOrientationLandscapeLeft) || (orientation == UIInterfaceOrientationLandscapeRight))
    {
        pageWidth = 480;
        pageHeight = 320;
    }
    else
    {
        pageWidth = 320;
        pageHeight = 480;
    }

    for (int i = 0; i < 5; i++)
    {
        int position = (i + offsetPage) % 5;
        views[i].frame = CGRectMake(position * pageWidth, 0, pageWidth, pageHeight); 
    }
    self.scrollView.contentSize = CGSizeMake(pageWidth * 5, pageHeight);
    self.scrollView.frame = CGRectMake(0, 0, pageWidth, pageHeight);
    self.scrollView.contentOffset = CGPointMake(pageWidth * 2, 0);
    
}
- (void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	//[self adjustClockLayoutWithOrientation:toInterfaceOrientation];
    if ((toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight))
	{
		self.scrollView.frame = CGRectMake(0, 0, 480, 320);
		self.scrollView.contentSize = CGSizeMake(2400, 320);
		[self.scrollView setContentOffset:CGPointMake(curClockIndex * 480, 0)];
		
		self.vwCyberView.frame = CGRectMake(0, 0, 480, 320);
		self.vwDigitalView.frame = CGRectMake(480, 0, 480, 320);
		self.vwGrandView.frame = CGRectMake(960, 0, 480, 320);
		self.vwPolarView.frame = CGRectMake(1440, 0, 480, 320);
		self.vwWordView.frame = CGRectMake(1920, 0, 480, 320);
		
      imgWordBackground.image = [UIImage imageNamed:@"word_clock_c00.png"];
		if (wordClockColor > 0)
			imgWordClockBackground.image = [UIImage imageNamed:[NSString stringWithFormat:@"word_clock_c0%d.png", wordClockColor]];
		else
			imgWordClockBackground.image = nil;
		imgWordClockBackground.frame = CGRectMake(76, 36, 353, 218);

	}
	else 
	{
        
		self.scrollView.frame = CGRectMake(0, 0, 320, 480);
		self.scrollView.contentSize = CGSizeMake(1600, 480);
		[self.scrollView setContentOffset:CGPointMake(curClockIndex * 320, 0)];
		self.vwCyberView.frame = CGRectMake(0, 0, 320, 480);
		self.vwDigitalView.frame = CGRectMake(320, 0, 320, 480);
		self.vwGrandView.frame = CGRectMake(640, 0, 320, 480);
		self.vwPolarView.frame = CGRectMake(960, 0, 320, 480);
		self.vwWordView.frame = CGRectMake(1280, 0, 320, 480);
		
        //vwFinacialBar.frame = CGRectMake(10, 354, 320, 58);
		//vwFinacialBar.frame = CGRectMake(0, 0, 320, 58);
		imgWordBackground.image = [UIImage imageNamed:@"word_clock_p_c00.png"];
		if (wordClockColor > 0)
			imgWordClockBackground.image = [UIImage imageNamed:[NSString stringWithFormat:@"word_clock_p_c0%d.png", wordClockColor]];
		else
			imgWordClockBackground.image = nil;
		imgWordClockBackground.frame = CGRectMake(0, 116, 320, 216);
		
		
	}
	[self adjustFinancialBarPosition:toInterfaceOrientation];
	
	
}

- (void) adjustFinancialBarPosition:(UIInterfaceOrientation) orientaion{
    float moveOffset;
    imgFinancialBar.transform = CGAffineTransformMakeTranslation(0, 0);
	if (orientaion == UIInterfaceOrientationLandscapeRight || orientaion == UIInterfaceOrientationLandscapeLeft)
	{
		if (curClockIndex == 4)
		{
			self.lblRate.frame = CGRectMake(30, 34, 120, 22);
			self.lblPercent.frame = CGRectMake (200, 34,60, 22);
			self.lblValue.frame = CGRectMake(300, 34, 200, 22);
            imgFinancialBar.frame = CGRectMake(0, 255, 480, 29);

		}
		else 
		{
			self.lblRate.frame = CGRectMake(30, 20, 120, 22);
			self.lblPercent.frame = CGRectMake (200, 20,60, 22);
			self.lblValue.frame = CGRectMake(300, 20, 200, 22);
            imgFinancialBar.frame = CGRectMake(0, 237, 480, 29);

		}

		moveOffset = 480.0;
	}
	else 
	{

		self.lblRate.frame = CGRectMake(10, 15, 120, 22);
		self.lblPercent.frame = CGRectMake (140, 15,60, 22);
		self.lblValue.frame = CGRectMake(200, 15, 120, 22);
        imgFinancialBar.frame = CGRectMake(0, 370, 320, 29);
        moveOffset = 320.0;
	}
	if ((orientaion == UIInterfaceOrientationLandscapeLeft || orientaion == UIInterfaceOrientationLandscapeRight) && curClockIndex == 4 )
	{
		self.btnFinance.frame = CGRectMake (79, 56, 49, 43);
	}
	else {
		self.btnFinance.frame = CGRectMake (79, 42, 49, 43);
	}
    
    CGAffineTransform moveTransform = CGAffineTransformMakeTranslation(curClockIndex * moveOffset, 0);
    imgFinancialBar.transform = moveTransform;
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[self moveAndShowButtons:curClockIndex];
}
#pragma mark -
#pragma mark WeatherAgentDelegate
- (void)didChangeWeather:(WeatherItem *)weatherItem {
    if (weatherItem == nil)
        return;
	lblWeather.text = [NSString stringWithFormat:@"%@ %@%@ %@%@", weatherItem.condition, weatherItem.temperature, weatherItem.unitTemperature, weatherItem.windSpeed, weatherItem.unitSpeed];
	NSString *keyWeather;
	if (curClockIndex == 0 || curClockIndex == 1 || curClockIndex == 3)
	{
		keyWeather = @"blue";
	}
	else if (curClockIndex == 2)
	{
		keyWeather = @"white";
	}
	else if (curClockIndex == 4)
	{
		keyWeather = @"dark_blue";
	}
	
	[self.imgWeather setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_%@.png", weatherItem.code, keyWeather]]];
	if (lblWeather.alpha == 0)
	{
		imgWeather.alpha = 0;
		lblWeather.alpha = 0;
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.3];
		lblWeather.alpha = 1;
		imgWeather.alpha = 1;
		[UIView commitAnimations];
	}
}

#pragma mark StockAgentDelegate

- (void)didChangeStock {
	StockItem *item = [[StockAgent sharedStockAgent] stockItemForSymbol:advancedInfo.stockSymbol];
	if (item == nil)
		return;
	lblValue.text = [NSString stringWithFormat:@"%@ %@", [[StockAgent sharedStockAgent].stockNameDictionary objectForKey:advancedInfo.stockSymbol], item.stockValue];
    if ([item.changePercent rangeOfString:@"-"].location == NSNotFound)
        lblPercent.text = [NSString stringWithFormat:@"+%@%%", item.changePercent];
    else
        lblPercent.text = [NSString stringWithFormat:@"%@%%", item.changePercent];
	if (lblValue.alpha == 0)
	{
		lblPercent.alpha = 0;
		lblValue.alpha = 0;
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.3];
		lblValue.alpha = 1;
		lblPercent.alpha = 1;
		[UIView commitAnimations];
	}
}

#pragma mark CurrencyAgentDelegate

- (void)didChangeCurrency:(CurrencyItem *)currencyItem {
	NSString *strCurrency = @"";
    
	if ([advancedInfo.currencyName isEqualToString:@"EUR/USD"])
		strCurrency = [NSString stringWithFormat:@"EUR : USD %1.3f", currencyItem.usd/currencyItem.eur];
	else if ([advancedInfo.currencyName isEqualToString:@"USD/JPY"])
		strCurrency = [NSString stringWithFormat:@"USD : JPY %1.3f", currencyItem.jpy/currencyItem.usd];
	else if ([advancedInfo.currencyName isEqualToString:@"GBP/USD"])
		strCurrency = [NSString stringWithFormat:@"GBP : USD %1.3f", currencyItem.usd/currencyItem.gbp];
	else if ([advancedInfo.currencyName isEqualToString:@"USD/CAD"])
		strCurrency = [NSString stringWithFormat:@"USD : CAD %1.3f", currencyItem.cad/currencyItem.usd];
	else if ([advancedInfo.currencyName isEqualToString:@"USD/HKD"])
		strCurrency = [NSString stringWithFormat:@"USD : HKD %1.3f", currencyItem.hkd/currencyItem.cny];
	else if ([advancedInfo.currencyName isEqualToString:@"USD/CNY"])
		strCurrency = [NSString stringWithFormat:@"USD : CNY %1.3f", currencyItem.cny/currencyItem.usd];
	else if ([advancedInfo.currencyName isEqualToString:@"AUD/USD"])
		strCurrency = [NSString stringWithFormat:@"AUD : USD %1.3f", currencyItem.usd/currencyItem.aud];
    
	lblRate.text = strCurrency;
    NSLog(strCurrency);
    
	if (lblRate.alpha == 0)
	{
		lblRate.alpha = 0;
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.3];
		lblRate.alpha = 1;
		[UIView commitAnimations];
	}
     
     
}
#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView1 {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
	[self performSelector:@selector(scrollViewDidEndScrollingAnimation:) withObject:scrollView1 afterDelay:0.1];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView1 {
	UIInterfaceOrientation curOrientation = [[UIApplication sharedApplication] statusBarOrientation];
	float moveOffset;
	if ((curOrientation == UIInterfaceOrientationLandscapeLeft) || (curOrientation == UIInterfaceOrientationLandscapeRight))
		moveOffset = 480.0;
	else 	
		moveOffset = 320.0;
	int clockIndex = scrollView.contentOffset.x / moveOffset;
	if (clockIndex == curClockIndex)
		return;
    bShowedButton = NO;
	curClockIndex = clockIndex;
    
	[self moveAndShowButtons:clockIndex];
    [self adjustFinancialBarPosition:curOrientation];
	
}

- (void) moveAndShowButtons:(int) offset {
	UIInterfaceOrientation curOrientation = [[UIApplication sharedApplication] statusBarOrientation];
	
	float moveOffset;
	if ((curOrientation == UIInterfaceOrientationLandscapeLeft) || (curOrientation == UIInterfaceOrientationLandscapeRight))
		moveOffset = 480.0;
	else 
		moveOffset = 320.0;
	


	//vwFinacialBar.frame = CGRectMake(80, 224, 320, 58);
	CGAffineTransform moveTransform = CGAffineTransformMakeTranslation(offset * moveOffset, 0);
	
	imgWeather.transform = moveTransform;
	imgThermoIcon.transform = moveTransform;
	lblWeather.transform = moveTransform;
	lblTempH.transform = moveTransform;
	lblTempL.transform = moveTransform;
	btnAlarm.transform = moveTransform;
	lblAlarm.transform = moveTransform;
	lblTempH.transform = moveTransform;
	vwFinacialBar.transform = moveTransform;
    imgFinancialBar.transform = moveTransform;
	btnInfo.transform = moveTransform;
	btnSetting.transform = moveTransform;
	vwPanelBottomRight.transform = moveTransform;
	imgWeather.alpha = 0;
	imgThermoIcon.alpha = 0;	
	lblWeather.alpha = 0;
	lblTempH.alpha = 0;
	lblTempL.alpha = 0;
	btnAlarm.alpha = 0;
	lblAlarm.alpha = 0;
	lblTempH.alpha = 0;
	btnSleep.alpha = 0;
	vwFinacialBar.alpha = 0;
    //G.W.
	btnInfo.alpha = 1;
    btnSetting.alpha = 1;
//    btnInfo.alpha = 0;
//    btnSetting.alpha = 0;
	vwPanelBottomRight.alpha = 0;
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.2];
	
	if ([WeatherAgent sharedWeatherAgent].weatherItem != nil)
	{
		imgWeather.alpha = 1;
		imgThermoIcon.alpha = 1;
		lblWeather.alpha = 1;
		lblTempH.alpha = 1;
		lblTempL.alpha = 1;
	}
	lblTempH.alpha = 1;
	vwFinacialBar.alpha = 1;
    imgFinancialBar.alpha = 1;
	if (bShowedButton)
    {
        btnSleep.alpha = 1;
        btnInfo.alpha = 1;
        vwPanelBottomRight.alpha = 1;
        btnAlarm.alpha = 1;
        lblAlarm.alpha = 1;
        btnSetting.alpha = 1;
    }
    [UIView commitAnimations];
	[self setCommonButtons:offset];
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    digitalClockColor = (digitalClockColor + 1)  % 3;
    [self setDigitalClockColor:digitalClockColor];
}

- (void) didTouch
{
    //G.W.
    
    if (bShowedButton == NO)
    {
        
        bShowedButton = YES;
        btnSetting.alpha = 0;
        btnSleep.alpha = 0;
        btnInfo.alpha = 0;
        vwPanelBottomRight.alpha = 0;
        btnAlarm.alpha = 0;
        lblAlarm.alpha = 0;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.8];
        
        
        btnSetting.alpha = 1;
        btnSleep.alpha = 1;
        btnInfo.alpha = 1;
        vwPanelBottomRight.alpha = 1;
        btnAlarm.alpha = 1;
        lblAlarm.alpha = 1;
        [UIView commitAnimations];
    }
    else
    {
        bShowedButton = NO;
        btnSetting.alpha = 1;
        btnSleep.alpha = 1;
        btnInfo.alpha = 1;
        btnAlarm.alpha = 1;
        lblAlarm.alpha = 1;
        vwPanelBottomRight.alpha = 1;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.8];
        
        
        btnSetting.alpha = 0;
        btnSleep.alpha = 0;
        btnInfo.alpha = 0;
        btnAlarm.alpha = 0;
        lblAlarm.alpha = 0;
        vwPanelBottomRight.alpha = 0;
        [UIView commitAnimations];
        
    }
  
}

- (void) setCommonButtons:(int) offset {
/*	imgWeather.alpha = 1;
	imgThermoIcon.alpha = 1;
	lblWeather.alpha = 1;
	lblTempH.alpha = 1;
	lblTempL.alpha = 1;
	btnAlarm.alpha = 1;
	lblAlarm.alpha = 1;
	lblTempH.alpha = 1;
	btnSleep.alpha = 1;
	vwFinacialBar.alpha = 1;
	btnInfo.alpha = 1;
	vwPanelBottomRight.alpha = 1;
 */
	UIColor *fontColor;
	NSString *key, *keyWeather;
	if (offset == 0 || offset == 1 || offset == 3)
	{
		fontColor = [UIColor colorWithRed:0 green:(162.0/255.0) blue:1.0 alpha:1.0];
		key = @"b";
		keyWeather = @"blue";
	}
	else if (offset == 2)
	{
		fontColor = [UIColor whiteColor];
		key = @"w";
		keyWeather = @"white";
	}
	else if (offset == 4)
	{
		fontColor = [UIColor colorWithRed:0 green:(56.0/255.0) blue:(88.0/255.0) alpha:1.0];
		key = @"db";
		keyWeather = @"dark_blue";
	}
	self.lblWeather.textColor = fontColor;
	self.lblTempH.textColor = fontColor;
	self.lblTempL.textColor = fontColor;
	self.lblRate.textColor = fontColor;
	self.lblPercent.textColor = fontColor;
	self.lblValue.textColor = fontColor;
	self.lblAlarm.textColor = fontColor;
	WeatherItem *item = [WeatherAgent sharedWeatherAgent].weatherItem;
	if (item != nil)
		[self.imgWeather setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_%@.png", item.code, keyWeather]]];
	[self.btnInfo setImage:[UIImage imageNamed:[NSString stringWithFormat:@"info_%@_btn00.png", key]] forState:UIControlStateNormal];
	[self.btnInfo setImage:[UIImage imageNamed:[NSString stringWithFormat:@"info_%@_btn01.png", key]] forState:UIControlStateHighlighted];
	[self.btnSleep setImage:[UIImage imageNamed:[NSString stringWithFormat:@"sleep_%@_btn00.png", key]] forState:UIControlStateNormal];
	[self.btnSleep setImage:[UIImage imageNamed:[NSString stringWithFormat:@"sleeep_%@_btn01.png", key]] forState:UIControlStateHighlighted];
	[self.btnSetting setImage:[UIImage imageNamed:[NSString stringWithFormat:@"setting_%@_btn00.png", key]] forState:UIControlStateNormal];
	[self.btnSetting setImage:[UIImage imageNamed:[NSString stringWithFormat:@"setting_%@_btn01.png", key]] forState:UIControlStateHighlighted];
	[self.btnAlarm setImage:[UIImage imageNamed:[NSString stringWithFormat:@"alarm_%@_btn00.png", key]] forState:UIControlStateNormal];
	[self.btnAlarm setImage:[UIImage imageNamed:[NSString stringWithFormat:@"alarm_%@_btn01.png", key]] forState:UIControlStateHighlighted];
	[self.btnFinance setImage:[UIImage imageNamed:[NSString stringWithFormat:@"finance_%@_btn00.png", key]] forState:UIControlStateNormal];
	[self.btnFinance setImage:[UIImage imageNamed:[NSString stringWithFormat:@"finance_%@_btn01.png", key]] forState:UIControlStateHighlighted];
	[self.btnColor setImage:[UIImage imageNamed:[NSString stringWithFormat:@"color_%@_btn00.png", key]] forState:UIControlStateNormal];
	[self.btnColor setImage:[UIImage imageNamed:[NSString stringWithFormat:@"color_%@_btn01.png", key]] forState:UIControlStateHighlighted];
	
		
    if (offset == 0)
    {
        self.imgFinancialBar.image = [UIImage imageNamed:@"cyber_finance bar.png"];
    }
    else if (offset == 1)
    {
        self.imgFinancialBar.image = [UIImage imageNamed:@"digital_finance bar.png"];
    }
    else if (offset == 2)
    {
        self.imgFinancialBar.image = [UIImage imageNamed:@"grand_finance bar.png"];
    }
    else if (offset == 3)
    {
        self.imgFinancialBar.image = [UIImage imageNamed:@"cyber_finance bar.png"];
    }
    else if (offset == 4)
    {
        self.imgFinancialBar.image = [UIImage imageNamed:@"word_finance bar.png"];
    }
}
#pragma mark -
#pragma mark memory management
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
	
	[curAlarmInfo release];
	[displayInfo release];
	
	//Main Views
	[scrollView release];
    //G.W.
	[vwCyberView release];
	[vwDigitalView release];
	[vwGrandView release];
	[vwPolarView release];
	[vwWordView release];
	
	//Common Buttons
	[vwPanelBottomRight release];
	[imgWeather release];
	[imgMask release];
	[lblWeather release];
	[lblTempH release];
	[lblTempL release];
	[btnAlarm release];
	[lblAlarm release];
	[btnSleep release];
	[lblRate release];
	[lblPercent release];
	[lblValue release];
	
	//Cyber Clock
	[imgCyberHour release];
	[imgCyberMinute release];
	[imgCyberSecond release];
	[imgThermoIcon release];
	[imgCyberClock release];
	[imgCyberBackground release];
	[imgCyberMinuteCover release];
	[imgCyberHourCover release];
	[lblCyberDay release];
	[lblCyberWeekday release];
	//Digital Clock
	[imgDigitalBackground release];
	[lblDigitalHour release];
	[lblDigitalMinute release];
	[lblDigitalSecond release];
	
	[lblDigitalHourBackground release];
	[lblDigitalMinuteBackground release];
	[lblDigitalSecondBackground release];
	
	[lblDigitalMonth release];
	[lblDigitalDay release];
	[lblDigitalWeekday release];
	
	[lblDigitalMonthCaption release];
	[lblDigitalDayCaption release];
	[lblDigitalWeekdayCaption release];
	
	[vwFinacialBar release];
    [imgFinancialBar release];
	[btnSetting release];
	[btnColor release];
	[btnInfo release];
	[lblDigitalColon release];
	[lblDigitalMonth release];
	[lblDigitalSlash release];
	
	
	
	//Grand Clock
	
	[imgGrandHour release];
	[imgGrandMinute release];
	[imgGrandSecond release];
	[imgGrandBackground release];
	[imgGrandClock release];
	[imgGrandSecondCover release];
	[lblGrandDay release];
	[lblGrandWeekday release];
	
	//Polar Clock
	[vwPolarClockContainer release];
	[imgPolarHour release];
	[imgPolarMinute release];
	[imgPolarSecond release];
	[imgPolarWeekday release];
	[imgPolarDay release];
	[vwPolarHour release];
	[vwPolarMinute release];
	[vwPolarSecond release];
	[vwPolarWeekday release];
	[vwPolarDay release];
	[lblPolarMonth release];
	[lblPolarDay1 release];
	[lblPolarDay2 release];
	[lblPolarWeekday release];
	[lblPolarHour1 release];
	[lblPolarHour2 release];
	[lblPolarMinute1 release];
	[lblPolarMinute2 release];
	[lblPolarSecond1 release];
	[lblPolarSecond2 release];
	
	//Word Clock
	
	[imgWordBackground release];
	[imgWordClockBackground release];
	[lblWordHour release];
	[lblWordMinute release];
	[lblWordSecond release];
	[lblWordMorning release];
	[lblWordYear release];
	[lblWordMonth release];
	[lblWordDay release];
	[lblWordWeekday release];
	[lblWordHourCaption release];
	[lblWordMinuteCaption release];
	[lblWordSecondCaption release];
	[imgWordFinanceBar release];
    [tailViewList release];
    [super dealloc];
}


@end