//
//  DisplayViewController.h
//  AlarmAndClock
//
//  Created by Alexandr on 11/2/11.
//  Copyright 2011 12345. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DisplayViewController : UIViewController<UITableViewDelegate> {

}

@property (nonatomic, retain) IBOutlet UITableView* tlbView;
@property (nonatomic, retain) UIBarButtonItem *doneBt;
@property (nonatomic, retain) UISlider* sliderBrightness;
@property (nonatomic, retain) NSMutableArray *sectionsArray;

- (void) changeBright:(UISlider *) sender;

@end
