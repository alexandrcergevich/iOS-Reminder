//
//  SoundMusicViewController.h
//  AlarmAndClock
//
//  Created by Alexandr on 11/2/11.
//  Copyright 2011 12345. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface SoundMusicViewController : UIViewController<UITableViewDelegate> {

}

@property (nonatomic, retain) IBOutlet UITableView* tlbView;
@property (nonatomic, retain) UIBarButtonItem *doneBt;
@property (nonatomic, retain) UISlider* soundVolume;

@property (nonatomic, assign) int nSelectAlarm;

@property (nonatomic, retain) NSMutableArray *sectionsArray;

@property (nonatomic, retain) IBOutlet AVAudioPlayer *audioPlayer;
- (void) changeVolume:(UISlider *) sender;

@end
