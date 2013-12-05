//
//  Database.h
//  TimesTables
//
//  Created by My-iMac on 8/31/11.
//  Copyright 2011 Zarang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AdvancedInfo;
NSMutableArray* alarmArray;
NSArray *alarmSoundArray;
AdvancedInfo *advancedInfo;
@interface AlarmInfo : NSObject

@property (nonatomic, retain) NSString* id_value;
@property (nonatomic, assign) int enable;
@property (nonatomic, assign) int hour;	
@property (nonatomic, assign) int minute;	
@property (nonatomic, assign) int am;
@property (nonatomic, retain) NSString* repeat;	
@property (nonatomic, retain) NSString* message;
@property (nonatomic, assign) int volume;
@property (nonatomic, assign) int sound;
@property (nonatomic, assign) int snooze;


@end

@interface DisplayInfo : NSObject

@property (nonatomic, assign) int show_second;
@property (nonatomic, assign) int show_day;	
@property (nonatomic, assign) int show_weather;	
@property (nonatomic, assign) int show_next_alarm;
@property (nonatomic, assign) int time_format;	
@property (nonatomic, assign) int temp_unit;
@property (nonatomic, assign) int dist_unit;
@property (nonatomic, assign) int bright;

@end

@interface AdvancedInfo : NSObject

@property (nonatomic, assign) int background_alarm;
@property (nonatomic, retain) NSString* location_woeid;
@property (nonatomic, retain) NSString* location_name;
@property (nonatomic, retain) NSString* stockSymbol;
@property (nonatomic, retain) NSString* currencyName;
@property (nonatomic, assign) int on_plugin;
@property (nonatomic, assign) int on_battery;
@property (nonatomic, assign) int postpone;
@property (nonatomic, assign) int snooze;

@end

@interface SongInfo : NSObject

@property (nonatomic, retain) NSString *persistentID;
@property (nonatomic, retain) NSString *songTitle;

@end

@interface Database : NSObject {
	
}
+ (void)logAllNotifications:(NSString *)message;
+(void) initDatabase:(NSString*)dbFile;
+(BOOL) addAlarmInfo:(AlarmInfo*)alarmInfo;
+(void) updateAlarmInfo:(AlarmInfo*)alarmInfo;
+(void) delAlarmInfo:(NSString*)id_val;

+(void) getDisplayInfo:(DisplayInfo*)displayInfo;
+(void) updateDisplayInfo:(DisplayInfo*)displayInfo;
+(NSArray*) getSongList;
+(void) updateSongList:(NSArray *)songList; 
+(void) getAdvancedInfo;
+(void) updateAdvancedInfo;
+(void) scheduleAlarmNotification;
+(void) disableAlarmsForNever:(NSDate *)lastTime;
@end

