//
//  AlarmAndClockAppDelegate.h
//  AlarmAndClock
//
//  Created by Alexandr on 10/30/11.
//  Copyright 2011 12345. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "AlarmViewController.h"
#import "customnavigator.h"

int globalLockCounter;
@protocol SleepAudioPlayerDelegate

- (void)timeChangedtoHour:(int)toHour andMinute:(int)toMinute andSecond:(int)toSecond;
@end
@interface CustomWindow:UIWindow {
}
@end;
@class ClockViewController;


@interface AlarmAndClockAppDelegate : NSObject <UIApplicationDelegate, UIAlertViewDelegate> {
    CustomWindow *window;
    AVAudioPlayer *audioPlayer;
	NSTimer* timer;
    int sleepHour, sleepMinute, sleepSecond;
    BOOL isSleeping;
    
    NSDate *startTime;
    int startHour;
    int startMinute;
    
    NSDate *endTime;   
    int endHour;
    int endMinute;
    
//    NSString *intervalHour;
//    NSString *intervalMin;
    int intervalHour;
    int intervalMin;
    
    BOOL vibrateState;
    BOOL m_DisplayRepeatStatus;
    BOOL m_DisplayStartTimeStatus;
    BOOL m_DisplayEndTimeStatus;
    BOOL m_DisplayIntervalStatus;
    BOOL m_DisplaySoundStatus;
    
//    UINavigationController *rootView;
    customnavigator *rootView;
    UIViewController *tempView;
    
}
@property (nonatomic, retain) customnavigator *rootView;
@property (nonatomic, retain) UIViewController *tempView;

@property BOOL isSleeping;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet ClockViewController *clockViewController;
@property (nonatomic, retain) IBOutlet AVAudioPlayer *audioPlayer;
@property (nonatomic, assign) id<SleepAudioPlayerDelegate> sleepDelegate;
@property (nonatomic, retain) NSDictionary *alarmUserinfo;

@property (nonatomic, retain) NSDate *startTime;
@property (nonatomic, assign) int startHour;
@property (nonatomic, assign) int startMinute;

@property (nonatomic, retain) NSDate *endTime;   
@property (nonatomic, assign) int endHour;
@property (nonatomic, assign) int endMinute;

//@property (nonatomic, retain) NSString *intervalHour;
//@property (nonatomic, retain) NSString *intervalMin;
@property (nonatomic, assign) int intervalHour;
@property (nonatomic, assign) int intervalMin;

@property (nonatomic, readwrite) BOOL vibrateState;
@property (nonatomic, readwrite) BOOL m_DisplayRepeatStatus;
@property (nonatomic, readwrite) BOOL m_DisplayStartTimeStatus;
@property (nonatomic, readwrite) BOOL m_DisplayEndTimeStatus;
@property (nonatomic, readwrite) BOOL m_DisplayIntervalStatus;
@property (nonatomic, readwrite) BOOL m_DisplaySoundStatus;

- (void) onTimer;
- (void)startSleepForHour:(int)hour andForMinute:(int)minute;
- (void)stopSleepHour;
- (void)requestSleepHour;
- (void)storeCurrentTime;

+ (AlarmAndClockAppDelegate*) sharedAppDelegate;

@end


