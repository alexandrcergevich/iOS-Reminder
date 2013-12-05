//
//  SleepAudioPlayer.h
//  AlarmAndClock
//
//  Created by Alexandr on 11/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "AlarmAndClockAppDelegate.h"


NSMutableArray *sleepMusicArray;

@interface SleepAudioPlayer : NSObject <AVAudioPlayerDelegate> {
	int  musicIndex;
    BOOL isPlaying;
}
@property (nonatomic, retain) NSTimer *sleepTimer;
@property (nonatomic, retain) AVAudioPlayer *player;
@property (nonatomic, assign) MPMusicPlayerController *musicPlayer;
@property (nonatomic, assign) NSNotificationCenter *notificationCenter;
@property (nonatomic, retain) NSArray *songList;
@property (nonatomic, assign) AlarmAndClockAppDelegate *delegate;
@property BOOL isPlaying;
- (void)startSleepMusic;
- (void)stopSleepMusic;
- (void)nowPlayingItemChanged:(NSNotification *)notification;
+ (SleepAudioPlayer *)sharedAudioPlayer;
@end
