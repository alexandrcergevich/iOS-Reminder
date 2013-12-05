//
//  AlarmAndClockAppDelegate.m
//  AlarmAndClock
//
//  Created by Alexandr on 10/30/11.
//  Copyright 2011 12345. All rights reserved.
//

#import "AlarmAndClockAppDelegate.h"
#import "ClockViewController.h"
#import "Database.h"
#import "Global.h"
#import "WeatherAgent.h"
#import "TestController.h"
#import "SleepAudioPlayer.h"
#import "customnavigator.h"


NSString * const BackModeTimer = @"BackModeTimer";


@implementation CustomWindow

- (void) sendEvent:(UIEvent *)event {
	if (event.type == UIEventTypeTouches)
	{
		globalLockCounter = 0;
		[[UIApplication sharedApplication] setIdleTimerDisabled:YES];
	}
	[super sendEvent:event];
	
}

@end

@implementation AlarmAndClockAppDelegate
@synthesize startTime;
@synthesize startHour;
@synthesize startMinute;
@synthesize endTime;
@synthesize endHour;
@synthesize endMinute;
@synthesize window;
@synthesize clockViewController;
@synthesize audioPlayer;
@synthesize sleepDelegate;
@synthesize isSleeping;
@synthesize alarmUserinfo;
@synthesize vibrateState;
@synthesize intervalHour;
@synthesize intervalMin;
@synthesize m_DisplayRepeatStatus;
@synthesize m_DisplayStartTimeStatus;
@synthesize m_DisplayEndTimeStatus;
@synthesize m_DisplayIntervalStatus;
@synthesize m_DisplaySoundStatus;

@synthesize rootView;
@synthesize tempView;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    	 
    [Database initDatabase:@"database.sqlite"];
    self.sleepDelegate = nil;
	NSThread* thread = [[NSThread alloc] initWithTarget:self selector:@selector(setup) object:nil];
	[thread start];
	
    // Override point for customization after application launch.
//	[window addSubview:clockViewController.view];
	
//    rootView = [[customnavigator alloc] initWithRootViewController:clockViewController];
    NSString *reqSysVer = @"6.0";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    
    if ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending)
    {
        [self.window addSubview:clockViewController.view]; //iOS 6
    } else {
        [self.window addSubview: clockViewController.view]; //iOS 5 or less
    }
    //	TestController *controller = [[[TestController alloc] init] autorelease];
    //	[window addSubview:controller.view];
    [self.window makeKeyAndVisible];
	
	[[UIApplication sharedApplication] setIdleTimerDisabled:YES];
	[SleepAudioPlayer sharedAudioPlayer].delegate = self;
	globalLockCounter = 0;
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    vibrateState = YES;
    m_DisplayRepeatStatus = FALSE;
    m_DisplayStartTimeStatus = FALSE;
    m_DisplayEndTimeStatus = FALSE;
    m_DisplayIntervalStatus = FALSE;
    m_DisplaySoundStatus = FALSE;    
    AlarmInfo *info = [[AlarmInfo alloc] init];
    startHour = info.hour;
    startMinute = info.minute;
    
    return YES;
}

+ (AlarmAndClockAppDelegate *)sharedAppDelegate
{
    return (AlarmAndClockAppDelegate *) [UIApplication sharedApplication].delegate;
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return (UIInterfaceOrientationMaskAll);
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}

- (void) setup
{
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	timer = [NSTimer scheduledTimerWithTimeInterval:(1.0) target:self selector:@selector(onTimer) userInfo:nil repeats:YES];	
	NSRunLoop* runLoop = [NSRunLoop currentRunLoop];
	[runLoop addTimer:timer forMode:NSRunLoopCommonModes];
	[runLoop run];
	[pool drain];
}

- (void) onTimer
{
	static int day = -1;
	NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents* now = [calendar components:(NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit) fromDate:[NSDate date]];
	NSInteger hour = [now hour];
	NSInteger minute = [now minute];
	NSInteger second = [now second];
	
	
	[calendar release];
	
	int curday = [now day];
	if (day == -1)
		day = curday;
	if (day != curday)
	{
		int month = [now month];
		int weekday = [now weekday];
		int year = [now year];
		day = curday;
		[clockViewController dateChanged:year month:month day:curday weekday:weekday animated:YES];
	}
	[clockViewController timeChanged:hour Min:minute Sec:second animated:YES];
	
	//Counter;
	int batteryState = [[UIDevice currentDevice] batteryState];
	if (((batteryState <= 1 && advancedInfo.on_battery) || (batteryState > 1 && advancedInfo.on_plugin))
		&& advancedInfo.postpone > 0)
	{
		globalLockCounter++;
		if (globalLockCounter >= advancedInfo.postpone * 60)
		{
			[[UIApplication sharedApplication] setIdleTimerDisabled:NO];
			globalLockCounter = 0;
		}
	}
	
    
    //SleepTimer
    if (isSleeping)
    {
        sleepSecond = sleepSecond - 1;

        if (sleepDelegate != nil)	
            [sleepDelegate timeChangedtoHour:sleepHour andMinute:sleepMinute andSecond:sleepSecond];
        if (sleepSecond == 0)
        {
            
            if (sleepMinute == 0)
            {
                if (sleepHour == 0)
                {
                    [self stopSleepHour];
                }
                else {
                    sleepHour = sleepHour - 1;
                    sleepMinute = 59;
                    sleepSecond = 60;
                }
                
            }
            else {
                sleepMinute = sleepMinute - 1;
                sleepSecond = 60;
            }
            
        }

    }
}

- (void)requestSleepHour 
{
    if (isSleeping)
    {
        if (sleepDelegate != nil)	
            [sleepDelegate timeChangedtoHour:sleepHour andMinute:sleepMinute andSecond:sleepSecond];
    }
}

- (void)startSleepForHour:(int)hour andForMinute:(int)minute {
	sleepHour = hour;
	sleepMinute = minute - 1;
	sleepSecond = 60;
	if (sleepMinute < 0)
	{
		sleepHour--;
		sleepMinute = 59;
	}
	[[SleepAudioPlayer sharedAudioPlayer] startSleepMusic];
    isSleeping = YES;
}

- (void)stopSleepHour {
    isSleeping = NO;
    [[SleepAudioPlayer sharedAudioPlayer] stopSleepMusic];
}
- (void)applicationWillResignActive:(UIApplication *)application {

    [self storeCurrentTime];
}

- (void)applicationDidBecomeActive:(UIApplication *)application 
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSDate *lastTime = (NSDate*)[standardUserDefaults objectForKey:@"lastTime"];
    [Database disableAlarmsForNever:lastTime];
}



- (void)storeCurrentTime 
{
    NSDate* now = [NSDate date];
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults)
    {
        [standardUserDefaults setObject:now forKey:@"lastTime"];
        [standardUserDefaults synchronize];

    }
}


//- (void)applicationDidEnterBackground:(UIApplication *)application {
//	if ([[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)]) {
//		[[NSNotificationCenter defaultCenter] addObserver:self
//												 selector:@selector(doBackground:)
//													 name:UIApplicationDidEnterBackgroundNotification
//												   object:nil];
//	}
//}


//- (void)applicationWillEnterForeground:(UIApplication *)application {
//
//	[[NSNotificationCenter defaultCenter]
//	 removeObserver:self
//	 name:UIApplicationDidEnterBackgroundNotification
//	 object:nil];
//}


- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{

    // Compairing

    
    NSCalendar* calendar = [NSCalendar currentCalendar];
	NSDateComponents* now = [calendar components:(NSHourCalendarUnit|NSMinuteCalendarUnit|NSWeekdayCalendarUnit|NSYearCalendarUnit|NSDayCalendarUnit|NSMonthCalendarUnit) fromDate:[NSDate date]];
	
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit |  NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
    NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease]; 
    NSDateComponents *alarmComps = [gregorian components: unitFlags fromDate: notification.fireDate];
    if ([now weekday] != [alarmComps weekday])
        return;
    
    NSLog(@"Ring Alarm > %d/%d/%d - %d:%d", alarmComps.year, alarmComps.month, alarmComps.day, alarmComps.hour, alarmComps.minute);
    
    NSDictionary *userInfo = notification.userInfo;
    self.alarmUserinfo = userInfo;
    UIAlertView *av;
    NSNumber *snoozeTime = [self.alarmUserinfo objectForKey:@"snooze"];
    if ([snoozeTime intValue] > 0)
        av = [[UIAlertView alloc] initWithTitle:[userInfo objectForKey:@"title"]
												 message:[userInfo objectForKey:@"message"]
												delegate:self
									   cancelButtonTitle:NSLocalizedString(@"Ok", @"")
									   otherButtonTitles:@"Snooze", nil];
    else
        av = [[UIAlertView alloc] initWithTitle:[userInfo objectForKey:@"title"]
                                        message:[userInfo objectForKey:@"message"]
                                       delegate:self
                              cancelButtonTitle:NSLocalizedString(@"Ok", @"")
                              otherButtonTitles:nil];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 50, 50)];
    [imageView setAlpha:0.3];
    NSString *imagepath = [[NSString alloc] initWithString:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"icon57.png"]];
    UIImage * image = [[UIImage alloc] initWithContentsOfFile:imagepath];
    [imageView setImage:image];   
    [av addSubview:imageView];
    
	[av show];
	[av release];
    
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"good!" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
//    [alertView show];
//    [alertView release];
    
//    NSString *soundFile = [userInfo objectForKey:@"sound"];
    NSString *soundFile = [self.alarmUserinfo objectForKey:@"sound"];
    NSLog(@"soundfile -> %@", soundFile);
    NSArray *soundFileComponents = [soundFile componentsSeparatedByString:@"."];
    NSString *soundFileEN = [soundFileComponents objectAtIndex:0];
	NSString *path = [[NSBundle mainBundle] pathForResource:soundFileEN ofType:@"caf"];
	NSURL *fileURL = [[[NSURL alloc] initFileURLWithPath:path] autorelease];
    NSNumber *volume = [notification.userInfo objectForKey:@"volume"];
	self.audioPlayer = [[[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil] autorelease];
	audioPlayer.numberOfLoops = 100;     
    float realVolume = [volume floatValue] / 100.0;
    [audioPlayer setVolume:realVolume];
	[audioPlayer prepareToPlay];
	[audioPlayer play];
    
    //Vibration G.W.
    
    if (vibrateState == YES){
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
    
    [self storeCurrentTime];    
     
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSDate *lastTime = (NSDate*)[standardUserDefaults objectForKey:@"lastTime"];
    [Database disableAlarmsForNever:lastTime];
    [clockViewController doAlarm];
    
    [self.audioPlayer stop];
    self.audioPlayer = nil;
    NSNumber *snoozeTime = [self.alarmUserinfo objectForKey:@"snooze"];
    if (buttonIndex == 1 && [snoozeTime intValue] > 0)
    {
        NSCalendar *calendar = [NSCalendar  autoupdatingCurrentCalendar];
        NSDateComponents* now = [calendar components:(NSHourCalendarUnit|NSMinuteCalendarUnit|NSWeekdayCalendarUnit|NSYearCalendarUnit|NSDayCalendarUnit|NSMonthCalendarUnit) fromDate:[NSDate date]];
        NSDateComponents *dateComps = [[NSDateComponents alloc] init];
        [dateComps setHour:[now hour]];	
        [dateComps setMinute:[now minute]];
        [dateComps setYear:[now year]];
        [dateComps setMonth:[now month]];
        [dateComps setDay:[now day]];
        NSLog(@"Snoozing" );
        NSDateComponents *addDate = [[NSDateComponents alloc] init];
        [addDate setMinute:[snoozeTime intValue]];
        
        NSDate *itemDate = [calendar dateByAddingComponents:addDate toDate:[calendar dateFromComponents:dateComps] options:0];
        [dateComps release];
        
        
        UILocalNotification *localNotif = [[UILocalNotification alloc] init];
        if (localNotif == nil)
            return;
        localNotif.fireDate = itemDate;
        
        localNotif.timeZone = [NSTimeZone defaultTimeZone];
        
        localNotif.alertBody = [self.alarmUserinfo objectForKey:@"title"];
        localNotif.alertAction = NSLocalizedString(@"Stop", nil);
        
        localNotif.soundName = [self.alarmUserinfo objectForKey:@"sound"];
        
     
        NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:[snoozeTime intValue]], @"snooze", 
                                  [self.alarmUserinfo objectForKey:@"message"], @"message", [self.alarmUserinfo objectForKey:@"sound"], @"sound", [self.alarmUserinfo objectForKey:@"volume"], @"volume", [self.alarmUserinfo objectForKey:@"title"], @"title", nil];
        localNotif.userInfo = infoDict;
        
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
        
//        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        [localNotif release];
        NSLog(@"Snoozing");
    }
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
	UIApplication *sharedApplication = [UIApplication sharedApplication] ;
	sharedApplication.idleTimerDisabled = NO;

}


- (void)doBackground:(NSNotification *)notification
{
	UIApplication* app = [UIApplication sharedApplication];
	if ([app respondsToSelector:@selector(beginBackgroundTaskWithExpirationHandler:)]) {
		UIBackgroundTaskIdentifier bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
			dispatch_async(dispatch_get_main_queue(), ^{
				if (bgTask != UIBackgroundTaskInvalid)
				{
					[app endBackgroundTask:bgTask];
					//bgTask = UIBackgroundTaskInvalid;
				}
			});
		}];
	}
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
	[clockViewController release];
	[timer release];
    [window release];
	[WeatherAgent releaseSharedWeatherAgent];
	[StockAgent releaseSharedStockAgent];
	[CurrencyAgent releaseSharedCurrencyAgent];
    [audioPlayer release];
    [alarmUserinfo release];
    [super dealloc];
}


@end
