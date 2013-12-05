//
//  Database.m
//  TimesTables
//
//  Created by My-iMac on 8/31/11.
//  Copyright 2011 Zarang. All rights reserved.
//

#import "Database.h"
#import <sqlite3.h>
#import "AlarmAndClockAppDelegate.h"

static sqlite3 *database = nil;
int compareTime(int hour1, int minute1, int hour2, int minute2)
{
    if (hour1 == hour2 && minute1 == minute2)
        return 0;
    if (hour1 > hour2 || (hour1 == hour2 && minute1 > minute2))
        return 1;
    return -1;
}
@implementation AlarmInfo

@synthesize id_value;
@synthesize enable;
@synthesize hour;	
@synthesize minute;	
@synthesize am;
@synthesize repeat;	
@synthesize message;
@synthesize volume;
@synthesize sound;
@synthesize snooze;


- (id) init
{
	[super init];
	id_value = @"";
	enable = 1;
	hour = 12;
	minute = 0;
	am = 1;
	repeat = @"";
	message = @"";
	volume = 50;
	sound = 0;
    snooze = 0;

	return self;
	
}

- (void) dealloc {
	[id_value release];
	[message release];
	[repeat release];
	[super dealloc];
}

@end

@implementation DisplayInfo

@synthesize show_second;
@synthesize show_day;	
@synthesize show_weather;	
@synthesize show_next_alarm;
@synthesize time_format;	
@synthesize temp_unit;
@synthesize dist_unit;
@synthesize bright;
- (id) init
{
	self = [super init];
	show_second = 1;
	show_day = 1;
	show_weather = 1;
	show_next_alarm = 1;
	time_format = 0;
	temp_unit = 0;
	dist_unit = 0;
	bright = 50;
	return self;
}

- (void) dealloc {
	[super dealloc];
}

@end

@implementation AdvancedInfo

@synthesize background_alarm, location_name,location_woeid, stockSymbol, currencyName;
@synthesize on_plugin, on_battery, postpone, snooze;

- (id) init
{
	self = [super init];
	background_alarm = 1;
	location_name = nil;
	location_woeid = nil;
	on_plugin = 1;
	on_battery = 0;
	postpone = 1;
    snooze = 0;
	return self;
}

- (void) dealloc {
	[location_name release];
	[location_woeid release];
	[stockSymbol release];
	[currencyName release];
	[super dealloc];
}

@end

@implementation SongInfo
@synthesize persistentID, songTitle;
-(id)init 
{
    self = [super init];
    self.persistentID = @"";
    self.songTitle = @"";
    return self;
}
-(void)dealloc {
    [persistentID release];
    [songTitle release];
    [super dealloc];
}

@end


NSString* databaseFile;
@implementation Database

+(void) initDatabase:(NSString*)dbFile
{
	alarmArray = [NSMutableArray new];
	
	databaseFile = dbFile;
	NSString* documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString* strDBPath = [documentDir stringByAppendingPathComponent:databaseFile];
	NSFileManager* fileMgr = [NSFileManager defaultManager];
	if ([fileMgr fileExistsAtPath:strDBPath] == NO) {
		NSString* dbPathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:dbFile];
        NSLog(@"Writing database file %@", dbPathFromApp);
		[fileMgr copyItemAtPath:dbPathFromApp toPath:strDBPath error:nil];
		[fileMgr release];
	}		

	if (sqlite3_open([strDBPath UTF8String], &database) == SQLITE_OK) {
		
		const char*sql = "select * from alarm_table";
		sqlite3_stmt* selectstmt;
		if (sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK) {
			while (sqlite3_step(selectstmt) == SQLITE_ROW) {
				AlarmInfo* alarmInfo = [[AlarmInfo alloc] init];
				alarmInfo.id_value = [NSString stringWithUTF8String:(char*)sqlite3_column_text(selectstmt, 1)];
				alarmInfo.enable = sqlite3_column_int(selectstmt, 2);
				alarmInfo.hour = sqlite3_column_int(selectstmt, 3);
				alarmInfo.minute = sqlite3_column_int(selectstmt, 4);
				alarmInfo.am = sqlite3_column_int(selectstmt, 5);
				alarmInfo.repeat = [NSString stringWithUTF8String:(char*)sqlite3_column_text(selectstmt, 6)];
				alarmInfo.message = [NSString stringWithUTF8String:(char*)sqlite3_column_text(selectstmt, 7)];
				alarmInfo.volume = sqlite3_column_int(selectstmt, 8);
				alarmInfo.sound = sqlite3_column_int(selectstmt, 9);
                alarmInfo.snooze = sqlite3_column_int(selectstmt, 10);
				[alarmArray addObject:alarmInfo];
				[alarmInfo release];
			}
			sqlite3_finalize(selectstmt);
		}
		else {
			NSLog(@"Database message : %s", sqlite3_errmsg(database));
		}
	}
	sqlite3_close(database);
	advancedInfo = [[AdvancedInfo alloc] init];
	[Database getAdvancedInfo];
	alarmSoundArray = [[NSArray alloc] initWithObjects:@"Alarm Modern", @"Alarm", @"Band", @"Blue", @"Child", @"Chinese", @"Club", @"Drum", @"Forest", @"Funny", @"Future", @"Guitar", @"Hiphop", @"Lounge", @"Music box", @"Piano", @"Relax", @"Remix", @"Rhythm", @"Sea", @"Violin", nil];
}

+(BOOL) addAlarmInfo:(AlarmInfo*)alarmInfo
{
	NSString* documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString* strDBPath = [documentDir stringByAppendingPathComponent:databaseFile];
	if (sqlite3_open([strDBPath UTF8String], &database) == SQLITE_OK) {
		
		// add  user info
		const char* sqlStatement1 = "insert into alarm_table (id_value, enable, hour, minute, am, repeat, message, volume, sound, snooze) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
		sqlite3_stmt* compiledStatement;
		if (sqlite3_prepare_v2(database, sqlStatement1, -1, &compiledStatement, NULL) == SQLITE_OK) {
			sqlite3_bind_text(compiledStatement, 1, [alarmInfo.id_value UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_int(compiledStatement, 2, alarmInfo.enable);
			sqlite3_bind_int(compiledStatement, 3, alarmInfo.hour);
			sqlite3_bind_int(compiledStatement, 4, alarmInfo.minute);
			sqlite3_bind_int(compiledStatement, 5, alarmInfo.am);
			sqlite3_bind_text(compiledStatement, 6, [alarmInfo.repeat UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(compiledStatement, 7, [alarmInfo.message UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_int(compiledStatement, 8, alarmInfo.volume);
			sqlite3_bind_int(compiledStatement, 9, alarmInfo.sound);	
			sqlite3_bind_int(compiledStatement, 10, alarmInfo.snooze);
            
			[alarmArray addObject:alarmInfo];
		}
		if (sqlite3_step(compiledStatement) != SQLITE_DONE) {
			NSLog(@"Database message : %s", sqlite3_errmsg(database));
			
			sqlite3_close(database);
			return NO;
		}
		else {
			sqlite3_last_insert_rowid(database);
		}
		sqlite3_finalize(compiledStatement);

		sqlite3_close(database);
		return YES;
	}
	
	sqlite3_close(database);
	return NO;
}

+(void) updateAlarmInfo:(AlarmInfo*)alarmInfo
{
	NSString* documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString* strDBPath = [documentDir stringByAppendingPathComponent:databaseFile];
	if (sqlite3_open([strDBPath UTF8String], &database) == SQLITE_OK) {
		const char* sqlStatement = "update alarm_table set enable=?, hour=?, minute=?, am=?, repeat=?, message=?, volume=?, sound=?, snooze=? where id_value=?";
		sqlite3_stmt* compiledStatement;
		if (sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			sqlite3_bind_int(compiledStatement, 1, alarmInfo.enable);
			sqlite3_bind_int(compiledStatement, 2, alarmInfo.hour);
			sqlite3_bind_int(compiledStatement, 3, alarmInfo.minute);
			sqlite3_bind_int(compiledStatement, 4, alarmInfo.am);
			sqlite3_bind_text(compiledStatement, 5, [alarmInfo.repeat UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(compiledStatement, 6, [alarmInfo.message UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_int(compiledStatement, 7, alarmInfo.volume);
			sqlite3_bind_int(compiledStatement, 8, alarmInfo.sound);
            sqlite3_bind_int(compiledStatement, 9, alarmInfo.snooze);
			sqlite3_bind_text(compiledStatement, 10, [alarmInfo.id_value UTF8String], -1, SQLITE_TRANSIENT);
		}
		if (sqlite3_step(compiledStatement) != SQLITE_DONE) {
			NSLog(@"Database message : %s", sqlite3_errmsg(database));
		}
		else {
			sqlite3_reset(compiledStatement);
		}		
		sqlite3_finalize(compiledStatement);
	}
	
	sqlite3_close(database);

}

+(void) delAlarmInfo:(NSString*)id_val
{
	NSString* documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString* strDBPath = [documentDir stringByAppendingPathComponent:databaseFile];
	if (sqlite3_open([strDBPath UTF8String], &database) == SQLITE_OK) {
		const char* sqlStatement = "delete from alarm_table where id_value=?";
		sqlite3_stmt* compiledStatement;
		if (sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			sqlite3_bind_text(compiledStatement, 1, [id_val UTF8String], -1, SQLITE_TRANSIENT);
		}
		if (sqlite3_step(compiledStatement) != SQLITE_DONE) {
			NSLog(@"Database message : %s", sqlite3_errmsg(database));
		}
		else {
			sqlite3_reset(compiledStatement);
		}	
		sqlite3_finalize(compiledStatement);
	}
	
	sqlite3_close(database);

}

+(void) getDisplayInfo:(DisplayInfo*)displayInfo
{
	if (displayInfo == nil)
		return;
	
	NSString* documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString* strDBPath = [documentDir stringByAppendingPathComponent:databaseFile];
	if (sqlite3_open([strDBPath UTF8String], &database) == SQLITE_OK) {
		const char*sql = "select * from display_table";
		sqlite3_stmt* selectstmt;
		if (sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK) {
			if (sqlite3_step(selectstmt) == SQLITE_ROW) {
				displayInfo.show_second = sqlite3_column_int(selectstmt, 1);
				displayInfo.show_day = sqlite3_column_int(selectstmt, 2);
				displayInfo.show_weather = sqlite3_column_int(selectstmt, 3);
				displayInfo.show_next_alarm = sqlite3_column_int(selectstmt, 4);
				displayInfo.time_format = sqlite3_column_int(selectstmt, 5);
				displayInfo.temp_unit = sqlite3_column_int(selectstmt, 6);
				displayInfo.dist_unit = sqlite3_column_int(selectstmt, 7);
				displayInfo.bright = sqlite3_column_int(selectstmt, 8);
			}
			sqlite3_finalize(selectstmt);
		}
		else {
			NSLog(@"Database message : %s", sqlite3_errmsg(database));
		}
	}
	
	sqlite3_close(database);
}

+(void) updateDisplayInfo:(DisplayInfo*)displayInfo
{
	if (displayInfo == nil)
		return;
	
	NSString* documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString* strDBPath = [documentDir stringByAppendingPathComponent:databaseFile];
	if (sqlite3_open([strDBPath UTF8String], &database) == SQLITE_OK) {
		const char* sqlStatement = "update display_table set show_second=?, show_day=?, show_weather=?, show_next_alarm=?, time_format=?, temp_unit=?, dist_unit=?, bright=?";
		sqlite3_stmt* compiledStatement;
		if (sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			sqlite3_bind_int(compiledStatement, 1, displayInfo.show_second);
			sqlite3_bind_int(compiledStatement, 2, displayInfo.show_day);
			sqlite3_bind_int(compiledStatement, 3, displayInfo.show_weather);
			sqlite3_bind_int(compiledStatement, 4, displayInfo.show_next_alarm);
			sqlite3_bind_int(compiledStatement, 5, displayInfo.time_format);
			sqlite3_bind_int(compiledStatement, 6, displayInfo.temp_unit);
			sqlite3_bind_int(compiledStatement, 7, displayInfo.dist_unit);
			sqlite3_bind_int(compiledStatement, 8, displayInfo.bright);
		}
		if (sqlite3_step(compiledStatement) != SQLITE_DONE) {
			NSLog(@"Database message : %s", sqlite3_errmsg(database));
		}
		else {
			sqlite3_reset(compiledStatement);
		}		
		sqlite3_finalize(compiledStatement);
	}
	sqlite3_close(database);
}

+(void) getAdvancedInfo
{

	
	NSString* documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString* strDBPath = [documentDir stringByAppendingPathComponent:databaseFile];
	if (sqlite3_open([strDBPath UTF8String], &database) == SQLITE_OK) {
		const char*sql = "select * from advanced_table";
		sqlite3_stmt* selectstmt;
		if (sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK) {
			if (sqlite3_step(selectstmt) == SQLITE_ROW) {
				advancedInfo.background_alarm = sqlite3_column_int(selectstmt, 1);
				advancedInfo.location_woeid = [NSString stringWithUTF8String:(char *) sqlite3_column_text(selectstmt, 2)];
				advancedInfo.location_name = [NSString stringWithUTF8String:(char *) sqlite3_column_text(selectstmt, 3)];
				advancedInfo.stockSymbol = [NSString stringWithUTF8String:(char *) sqlite3_column_text(selectstmt, 4)];
				advancedInfo.currencyName = [NSString stringWithUTF8String:(char *) sqlite3_column_text(selectstmt, 5)];
				advancedInfo.on_plugin = sqlite3_column_int(selectstmt, 6);
				advancedInfo.on_battery = sqlite3_column_int(selectstmt, 7);
				advancedInfo.postpone = sqlite3_column_int(selectstmt, 8);
                advancedInfo.snooze = sqlite3_column_int(selectstmt, 9);
			}
			sqlite3_finalize(selectstmt);
			NSLog(@"Advanded Info - %d, %@, %@, %d, %d, %d", advancedInfo.background_alarm, advancedInfo.location_woeid, advancedInfo.location_name, advancedInfo.on_plugin, advancedInfo.on_battery, advancedInfo.postpone);
		}
		else {
			NSLog(@"Database message : %s", sqlite3_errmsg(database));
		}
	}
	
	sqlite3_close(database);
}

+(void) updateAdvancedInfo
{

	NSString* documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString* strDBPath = [documentDir stringByAppendingPathComponent:databaseFile];
	NSLog(@"Changed: %@ %d", advancedInfo.location_woeid, advancedInfo.snooze);
	if (sqlite3_open([strDBPath UTF8String], &database) == SQLITE_OK) {
		const char* sqlStatement = "update advanced_table set background_alarm=?, location_woeid=?, location_name=?, stock_symbol=?, currency_name=?, on_plugin=?, on_battery=?, postpone=?, snooze=?";
		sqlite3_stmt* compiledStatement;
		if (sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			sqlite3_bind_int(compiledStatement, 1, advancedInfo.background_alarm);
			sqlite3_bind_text(compiledStatement, 2, [advancedInfo.location_woeid UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(compiledStatement, 3, [advancedInfo.location_name UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(compiledStatement, 4, [advancedInfo.stockSymbol UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(compiledStatement, 5, [advancedInfo.currencyName UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_int(compiledStatement, 6, advancedInfo.on_plugin);
			sqlite3_bind_int(compiledStatement, 7, advancedInfo.on_battery);
			sqlite3_bind_int(compiledStatement, 8, advancedInfo.postpone);
            sqlite3_bind_int(compiledStatement, 9, advancedInfo.snooze);
		}
		if (sqlite3_step(compiledStatement) != SQLITE_DONE) {
			NSLog(@"Database message : %s", sqlite3_errmsg(database));
		}
		else {
			sqlite3_reset(compiledStatement);
		}		
		sqlite3_finalize(compiledStatement);
	}
	sqlite3_close(database);
	
	
}

+(NSArray *)getSongList;
{
    NSMutableArray *songList = [NSMutableArray array];
    
    NSString* documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString* strDBPath = [documentDir stringByAppendingPathComponent:databaseFile];
	if (sqlite3_open([strDBPath UTF8String], &database) == SQLITE_OK) {
		const char*sql = "select * from song_table";
		sqlite3_stmt* selectstmt;
		if (sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK) {
			while (sqlite3_step(selectstmt) == SQLITE_ROW) {
                SongInfo *info = [[[SongInfo alloc] init] autorelease];
                info.persistentID = [NSString stringWithUTF8String:(char *) sqlite3_column_text(selectstmt, 1)];
                info.songTitle = [NSString stringWithUTF8String:(char *) sqlite3_column_text(selectstmt, 2)];
                [songList addObject:info];
			}
			sqlite3_finalize(selectstmt);
		}
		else {
			NSLog(@"Database message : %s", sqlite3_errmsg(database));
		}
	}
	
	sqlite3_close(database);
    return songList;
    
}

+(void) updateSongList:(NSArray *)songList
{
    
	NSString* documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString* strDBPath = [documentDir stringByAppendingPathComponent:databaseFile];
    
	if (sqlite3_open([strDBPath UTF8String], &database) == SQLITE_OK) {
		sqlite3_stmt* compiledStatement;
        const char* sqlStatement1 = "delete from song_table";
        if (sqlite3_prepare_v2(database, sqlStatement1, -1, &compiledStatement, NULL) == SQLITE_OK) {
            
            
        }
        if (sqlite3_step(compiledStatement) != SQLITE_DONE) {
        }
        else {
            sqlite3_reset(compiledStatement);
            NSLog(@"Database message : %s", sqlite3_errmsg(database));
          
        }		
        sqlite3_finalize(compiledStatement);
        NSLog(@"We are going to update %d", [songList count]);
        for (SongInfo *info in songList)
        {
            const char* sqlStatement = "insert into song_table(persistent_id, song_title) values(?,?)";
            if (sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {

                sqlite3_bind_text(compiledStatement, 1, [info.persistentID UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(compiledStatement, 2, [info.songTitle UTF8String], -1, SQLITE_TRANSIENT);
            }
            if (sqlite3_step(compiledStatement) != SQLITE_DONE) {
                NSLog(@"Database message : %s", sqlite3_errmsg(database));
            }
            else {
                sqlite3_reset(compiledStatement);
            }		
            sqlite3_finalize(compiledStatement);
        }
        
	}
	sqlite3_close(database);
	
	
}
+(void) scheduleAlarmNotification {
	NSCalendar* calendar = [NSCalendar currentCalendar];
	NSDateComponents* now = [calendar components:(NSHourCalendarUnit|NSMinuteCalendarUnit|NSWeekdayCalendarUnit|NSYearCalendarUnit|NSDayCalendarUnit|NSMonthCalendarUnit) fromDate:[NSDate date]];
	
	NSInteger nowWeek = [now weekday]-1;
	
	NSArray *weekArray = [NSArray arrayWithObjects:@"Sun", @"Mon", @"Tue", @"Wed", @"Thu", @"Fri", @"Sat", nil];
	UIApplication *app                = [UIApplication sharedApplication];
	NSArray *oldNotifications         = [app scheduledLocalNotifications];
	
	if ([oldNotifications count] > 0) {
		[app cancelAllLocalNotifications];
	}
	for (AlarmInfo *alarmInfo in alarmArray) 
	{
        if (alarmInfo.enable == 0)
            continue;
		for (int weekday = nowWeek; weekday < nowWeek + 7; weekday++)
		{
            
			NSArray *alarmDays = [alarmInfo.repeat componentsSeparatedByString:@" "];
			int containWeek = 0;
			if ([alarmInfo.repeat isEqualToString:@"Every Day"] || [alarmInfo.repeat isEqualToString:@"Never"])
			{
				containWeek = 1;
			}
			if (containWeek == 0)
			{
				for (NSString *item in alarmDays)
				{
					if ([[weekArray objectAtIndex:(weekday % 7)] isEqualToString:item])
					{
						containWeek = 1;
					}
				}
			}
			if (containWeek == 1)
			{
				//Registering Notification
				
				NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
				NSDateComponents *dateComps = [[NSDateComponents alloc] init];
				[dateComps setHour:alarmInfo.hour];	
				[dateComps setMinute:alarmInfo.minute];
				[dateComps setYear:[now year]];
				[dateComps setMonth:[now month]];
				[dateComps setDay:[now day]];
				
                if ([alarmInfo.repeat isEqualToString:@"Never"])
                {
                    if (weekday == nowWeek && (alarmInfo.hour < [now hour] || (alarmInfo.hour == [now hour] && alarmInfo.minute <= [now minute])))
                        continue;
                }
				NSDateComponents *addDate = [[NSDateComponents alloc] init];
				[addDate setDay:(weekday - nowWeek)%7];
				
				NSDate *itemDate = [calendar dateByAddingComponents:addDate toDate:[calendar dateFromComponents:dateComps] options:0];
				[dateComps release];
				NSDateComponents *newDateComps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSWeekdayCalendarUnit fromDate:itemDate];
				NSLog(@"Alarm Dates: %d/%d/%d - %d:%d  %@", [newDateComps year], [newDateComps month], [newDateComps day], [newDateComps hour], [newDateComps minute], [weekArray objectAtIndex:([newDateComps weekday]-1)] );
																									
				UILocalNotification *localNotif = [[UILocalNotification alloc] init];
				if (localNotif == nil)
					return;
				localNotif.fireDate = itemDate;
				
				localNotif.timeZone = [NSTimeZone defaultTimeZone];
//				NSString *title = [NSString stringWithFormat:@"Alarm set to %02d:%02d",alarmInfo.hour, alarmInfo.minute];
                NSString *title = [NSString stringWithFormat:@"%@", alarmInfo.message];
//                NSString *title = @" ";
                localNotif.alertBody = title;
				localNotif.alertAction = NSLocalizedString(@"Ok", nil);
				
                //if (![alarmInfo.repeat isEqualToString:@"Never"])
                localNotif.repeatInterval = NSWeekCalendarUnit;
                NSString *soundName = [NSString stringWithFormat:@"%@.caf", [alarmSoundArray objectAtIndex:alarmInfo.sound]];
                NSLog(@"alarmInfo.sound-> %d", alarmInfo.sound);
                localNotif.soundName = soundName;
                //@"Alarm.mp3";
//				NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:alarmInfo.snooze], @"snooze", 
//                                          alarmInfo.message, @"message", soundName, @"sound", [NSNumber numberWithInt:alarmInfo.volume], @"volume", title, @"title", nil];
                NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:alarmInfo.snooze], @"snooze", 
                                          @" ", @"message", soundName, @"sound", [NSNumber numberWithInt:alarmInfo.volume], @"volume", title, @"title", nil];
				localNotif.userInfo = infoDict;
				
				[[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
				[localNotif release];
                if ([alarmInfo.repeat isEqualToString:@"Never"])
                {
                    break;
                }
				 
			}
		}
	}
	
    

}

+(void) disableAlarmsForNever:(NSDate *)lastTime
{
    if (lastTime == nil)
        return;
	NSCalendar* calendar = [NSCalendar currentCalendar];
	NSDateComponents* now = [calendar components:(NSHourCalendarUnit|NSMinuteCalendarUnit|NSWeekdayCalendarUnit|NSYearCalendarUnit|NSDayCalendarUnit|NSMonthCalendarUnit) fromDate:[NSDate date]];
    NSDateComponents* last = [calendar components:(NSHourCalendarUnit|NSMinuteCalendarUnit|NSWeekdayCalendarUnit|NSYearCalendarUnit|NSDayCalendarUnit|NSMonthCalendarUnit) fromDate: lastTime];
	
    NSLog(@"%d year, %d month, %d day, %d hour, %d minute", [last year], [last month], [last day], [last hour], [last minute]);
	for (AlarmInfo *alarmInfo in alarmArray) 
	{
        if (![alarmInfo.repeat isEqualToString:@"Never"])
            continue;
        if (alarmInfo.enable == 0)
            continue;
        if ([last year] < [now year])
            continue;
        if ([last month] < [now month])
            continue;
        if ([now day] - [last day] > 1)
            continue;
        if ([last day] < [now day])
        {
            if (compareTime(alarmInfo.hour, alarmInfo.minute, [last hour], [last minute]) <= 0 ||
                compareTime(alarmInfo.hour, alarmInfo.minute, [now hour], [now minute]) > 0)
                continue;
            alarmInfo.enable = 0;
            [Database updateAlarmInfo:alarmInfo];
        }
        else if ([last day] == [now day])
        {
            if (compareTime(alarmInfo.hour, alarmInfo.minute, [now hour], [now minute]) > 0)
                continue;
            alarmInfo.enable = 0;
            [Database updateAlarmInfo:alarmInfo];
        }
        
	}
    [Database scheduleAlarmNotification];
    
}

+ (void)logAllNotifications:(NSString *)message
{
    NSLog(@"------------------------------------------------");
    if (message)
        NSLog(@"%@", message);
    
    NSArray *schedule = [UIApplication sharedApplication].scheduledLocalNotifications;
	
	int count = [schedule count];
    //Getting Schedules;
	for (int idx = 0; idx < count; idx++) {
		
		id obj = [schedule objectAtIndex: idx];
		if (obj && [obj isKindOfClass:[UILocalNotification class]]) {
            
            unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit |  NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
            NSLog(@"Notification %d > ", idx);
            UILocalNotification *wakeUp = (UILocalNotification *)obj;
            NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease]; 
            NSDateComponents *logAlarmComps = [gregorian components: unitFlags fromDate: wakeUp.fireDate];
            NSLog(@"Fire Date: %d/%d/%d - %d:%d", [logAlarmComps year], [logAlarmComps month], [logAlarmComps day], [logAlarmComps hour], [logAlarmComps minute] );
            
            /*
             wakeUp.timeZone = [NSTimeZone localTimeZone];
             wakeUp.repeatInterval = NSMinuteCalendarUnit;
             wakeUp.alertAction = @"Wake Up";
             wakeUp.alertBody = @"Open Alarm Clock to turn off the alarm.";
             wakeUp.hasAction = YES;
             // wakeUp.alertLaunchImage = // choose an image to show when app is started by the alert...
             wakeUp.soundName = @"Rooster.wav";
             wakeUp.userInfo = [NSDictionary dictionaryWithObjectsAndKeys: @"wakeup", kUserInfoNotificationType, [NSNumber numberWithInt: tag], kUserInfoAlarmTag, nil];
             
             
             id value = [((UILocalNotification *)obj).userInfo objectForKey: kUserInfoAlarmTag];
             
             if (value && [value isKindOfClass: [NSNumber class]]) {
             if ([(NSNumber *)value intValue] == self->tag) {
             return (UILocalNotification *)obj;
             }
            */
            
		}
		
	}
    
}
@end
