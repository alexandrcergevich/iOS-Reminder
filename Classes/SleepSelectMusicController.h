//
//  SleepSelectMusicController.h
//  AlarmAndClock
//
//  Created by Alexandr on 11/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
@interface SleepSelectMusicController : UITableViewController <MPMediaPickerControllerDelegate>
{
    BOOL isEditing;
}
@property (nonatomic, retain) NSMutableArray *songList;
-(void)addAction:(id)sender;
@end
