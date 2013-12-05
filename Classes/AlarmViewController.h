//
//  AlarmViewController.h
//  AlarmAndClock
//
//  Created by Alexandr on 10/31/11.
//  Copyright 2011 12345. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlarmViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIAlertViewDelegate> {
	UITextField *msgTextField;
	UILabel *lblRepeat;
    UILabel *lblRepeat1;
    UILabel *lblRepeat2;
    UILabel *lblRepeat3;
//G.W.
    BOOL m_Vibrate;
    //	BOOL bEnableAlarm;
	NSString* strRepeat;
	int selectSound;
//	NSString* strMessage;
    IBOutlet UISwitch *btn_vibrate;

}

@property (nonatomic, retain) NSString *strMessage;
@property (nonatomic, retain) IBOutlet UITableView* tlbView;
@property (nonatomic, retain) UIBarButtonItem *doneBt;
@property (nonatomic, retain) IBOutlet UIDatePicker *timePicker;
@property (nonatomic, assign) int	nSelectAlarm;
		
@end
