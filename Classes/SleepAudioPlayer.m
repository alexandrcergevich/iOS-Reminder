//
//  SleepAudioPlayer.m
//  AlarmAndClock
//
//  Created by Alexandr on 11/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SleepAudioPlayer.h"
#import "Database.h"

@implementation SleepAudioPlayer
@synthesize player, sleepTimer, isPlaying, songList;
@synthesize  musicPlayer, notificationCenter, delegate;
static SleepAudioPlayer *_audioPlayer;

+ (SleepAudioPlayer *) sharedAudioPlayer {
	if (_audioPlayer == nil) {
		_audioPlayer = [[SleepAudioPlayer alloc] init];
        _audioPlayer.musicPlayer = [MPMusicPlayerController applicationMusicPlayer];
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        
        [notificationCenter addObserver: _audioPlayer
                               selector: @selector (nowPlayingItemChanged:)
                                   name: MPMusicPlayerControllerPlaybackStateDidChangeNotification
                                 object: _audioPlayer.musicPlayer];
        [_audioPlayer.musicPlayer beginGeneratingPlaybackNotifications];
	}

    
	return _audioPlayer;
}

- (void)startSleepMusic{
	musicIndex = 0;
	
    [self stopSleepMusic];
    self.isPlaying = YES;
    self.songList = [Database getSongList];
    MPMediaQuery *mediaQuery;
    for (musicIndex = 0; musicIndex < [self.songList count]; musicIndex ++)
    {
        SongInfo *info = [self.songList objectAtIndex:musicIndex];
        mediaQuery = [MPMediaQuery songsQuery];
        MPMediaPropertyPredicate *filter = [MPMediaPropertyPredicate predicateWithValue:info.songTitle forProperty:MPMediaItemPropertyTitle];
        [mediaQuery addFilterPredicate:filter];
        if ([[mediaQuery collections] count] > 0)
            break;
    }
    if (musicIndex < [self.songList count])
    {
        [self.musicPlayer setQueueWithQuery:mediaQuery];
        [self.musicPlayer play];
    }
}

- (void)nowPlayingItemChanged:(NSNotification *)notification {
    if (isPlaying && [self.musicPlayer playbackState] == MPMusicPlaybackStateStopped)
    {
        int i;
        MPMediaQuery *mediaQuery;
        for (i = musicIndex + 1;i <= [self.songList count] + musicIndex; i++)
        {
            SongInfo *info = [self.songList objectAtIndex:(i%[self.songList count])];
            mediaQuery = [MPMediaQuery songsQuery];
            MPMediaPropertyPredicate *filter = [MPMediaPropertyPredicate predicateWithValue:info.songTitle forProperty:MPMediaItemPropertyTitle];
            [mediaQuery addFilterPredicate:filter];
            if ([[mediaQuery collections] count] > 0)
                break;
        }
        if (i <= [self.songList count] + musicIndex)
        {
            musicIndex = i;
            [self.musicPlayer setQueueWithQuery:mediaQuery];
            [self.musicPlayer play];
            
        }
    }
    
}
- (void)sleepTimerAction{
	
}

-(void)stopSleepMusic {
    if (self.isPlaying == NO)
        return;
    self.isPlaying = NO;
/*    if (self.player)
    {
        [self.player stop];
        self.player = nil;
        
    } */
    [self.musicPlayer stop];
    [sleepTimer invalidate];
    self.sleepTimer = nil;
}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)playerOld successfully:(BOOL)flag
{
	[player stop];
    self.player = nil;
	musicIndex = musicIndex + 1;
	if (musicIndex >= [sleepMusicArray count])
		musicIndex = 0;
	NSString *path = [[NSBundle mainBundle] pathForResource:[sleepMusicArray objectAtIndex:musicIndex] ofType:@"mp3"];
	NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:path];
	
	self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
	player.numberOfLoops = 0;
	player.volume = 1.0;
	player.delegate = self;
	[player prepareToPlay];
	[player play];

}
- (void)dealloc{
	[player release];
	[sleepTimer release];
	[super dealloc];
}
@end
