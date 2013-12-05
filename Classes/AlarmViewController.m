//
//  AlarmViewController.m
//  AlarmAndClock
//
//  Created by Alexandr on 10/31/11.
//  Copyright 2011 12345. All rights reserved.
//

#import "AlarmViewController.h"
#import "RepeatAlarmViewController.h"
#import "SoundMusicViewController.h"
#import "AlarmAndClockAppDelegate.h"
#import "Database.h"
#import "Global.h"
#import "SnoozeSettingController.h"
#import "StartTimerViewController.h"
#import "EndTimeViewController.h"
#import "IntervalTimeViewController.h"

@implementation AlarmViewController

@synthesize tlbView;
@synthesize doneBt;
@synthesize timePicker;
@synthesize nSelectAlarm;
@synthesize strMessage;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	m_Vibrate = YES;
	strRepeat = @"Never";
	selectSound = 0;
	self.strMessage = @"";
	
	doneBt = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
	
	self.navigationItem.rightBarButtonItem = doneBt;
    //G.W.
//	self.navigationItem.title = @"Alarm";	
    self.navigationItem.title = @"Reminder";
    
    AlarmAndClockAppDelegate *delegate = (AlarmAndClockAppDelegate*)[[UIApplication sharedApplication] delegate];
    delegate.m_DisplayRepeatStatus = FALSE;
    delegate.m_DisplayStartTimeStatus = FALSE;
    delegate.m_DisplayEndTimeStatus = FALSE;
    delegate.m_DisplayIntervalStatus = FALSE;
    delegate.m_DisplaySoundStatus = FALSE;
    
//    delegate.startHour = 0;
//    delegate.startMinute = 0;
//    delegate.endHour = 0;
//    delegate.endMinute = 0;
//    delegate.intervalHour = 0;
//    delegate.intervalMin = 0;
}


- (NSDate*) dateToGMT:(NSDate*)sourceDate
{
	
	NSTimeZone* destTimeZone = [NSTimeZone localTimeZone];
	NSInteger destGMTOffset = [destTimeZone secondsFromGMTForDate:sourceDate];
	NSDate* destDate = [[[NSDate alloc] initWithTimeInterval:destGMTOffset sinceDate:sourceDate] autorelease];
	return destDate;

	return sourceDate;
}

- (NSDate*) GMTTodate:(NSDate*)sourceDate
{
	
	NSTimeInterval timeZoneOffset = [[NSTimeZone localTimeZone] secondsFromGMT];
	NSTimeInterval gmtTimeInterval = [sourceDate timeIntervalSinceReferenceDate]-timeZoneOffset;
	NSDate* gmtDate = [NSDate dateWithTimeIntervalSinceReferenceDate:gmtTimeInterval];
	return gmtDate;
	 
	return sourceDate;
}

- (void)viewWillAppear:(BOOL)animated
{
//    AlarmAndClockAppDelegate *delegate = (AlarmAndClockAppDelegate*)[[UIApplication sharedApplication] delegate];
   
	if (nSelectAlarm == -1)
		return;
//    if ((delegate.m_DisplayRepeatStatus == TRUE) || (delegate.m_DisplayStartTimeStatus == TRUE) || (delegate.m_DisplayEndTimeStatus == TRUE) || (delegate.m_DisplayIntervalStatus == TRUE) || (delegate.m_DisplaySoundStatus == TRUE)){
       
        AlarmInfo* alarmInfo = (AlarmInfo*)[alarmArray objectAtIndex:nSelectAlarm];
        m_Vibrate = alarmInfo.enable;
        strRepeat = alarmInfo.repeat;
        selectSound = alarmInfo.sound;
        NSLog(@"SelectSound-> %d", selectSound);
    NSLog(@"alarmInfo.message -> %@", alarmInfo.message);
        strMessage = alarmInfo.message;
        msgTextField.text = alarmInfo.message;
        [tlbView reloadData];
    
        DisplayInfo* displayInfo = [[DisplayInfo alloc] init];
        [Database getDisplayInfo:displayInfo];
        
        NSDateComponents* comps = [[NSDateComponents alloc] init];
        [comps setHour:alarmInfo.hour];
        [comps setMinute:alarmInfo.minute];
        NSLog(@"%d %d", alarmInfo.hour, alarmInfo.minute);
        self.timePicker.timeZone = [NSTimeZone defaultTimeZone];
        NSDate* newDate = [[NSCalendar currentCalendar] dateFromComponents:comps];
        
        self.timePicker.date = newDate;         
//    }    
}


- (void) setNotificationByDate:(NSDate *) dt
					   message:(NSString *) msg
						 sound:(BOOL) useSound
{
	UIApplication *app = [UIApplication sharedApplication];
	NSArray *oldNotifications = [app scheduledLocalNotifications];
	
 	if ([oldNotifications count] > 0)
	{
		[app cancelAllLocalNotifications];
	}
	
	UILocalNotification* alarm = [[[UILocalNotification alloc] init] autorelease];
	if (alarm)
	{
		alarm.fireDate = dt;
		alarm.timeZone = [NSTimeZone localTimeZone];
		alarm.repeatInterval = 0;
		if (useSound)
		{
			alarm.soundName = @"none.caf";
		}
		alarm.alertBody = msg;
		[app scheduleLocalNotification:alarm];
    }
}


- (void)viewWillDisappear:(BOOL)animated
{ 
	self.strMessage = msgTextField.text;
	[msgTextField resignFirstResponder];

	if (nSelectAlarm == -1) {
		if([alarmArray count] == 0)    //Smile 2012/07/23  When set the second reminder alarm, no create the "12:00" alarmInfo.
        {
            NSLog(@"alarmArray count -> %d", [alarmArray count]);
            AlarmInfo* alarmInfo = [[AlarmInfo alloc] init];
            alarmInfo.id_value = [NSString stringWithFormat:@"%d", (int)[[NSDate date] timeIntervalSince1970]];
            alarmInfo.enable = m_Vibrate;
	
            NSDate* now = [self dateToGMT:self.timePicker.date];
            NSString* dateString = [now description];
            NSArray* arr1 = [dateString componentsSeparatedByString:@" "];
            NSString* time = (NSString*)[arr1 objectAtIndex:1];
            NSArray* arr2 = [time componentsSeparatedByString:@":"];
            NSString* sHour = (NSString*)[arr2 objectAtIndex:0];
            NSString* sMinute = (NSString*)[arr2 objectAtIndex:1];
	
            alarmInfo.hour = [sHour intValue];
            alarmInfo.minute = [sMinute intValue];
            alarmInfo.am = (alarmInfo.hour<12?0:1);
	
            alarmInfo.repeat = strRepeat;
            alarmInfo.message = self.strMessage;
            NSLog(@"message -> %@", alarmInfo.message);
            alarmInfo.volume = 50;
        
            [Database addAlarmInfo:alarmInfo];
            [Database scheduleAlarmNotification];
            [alarmInfo release];		
        }
        nSelectAlarm = [alarmArray count]-1;

	}
	else {
        NSLog(@"alarmArray count -> %d", [alarmArray count]);   
		AlarmInfo* alarmInfo = (AlarmInfo*)[alarmArray objectAtIndex:nSelectAlarm];
		alarmInfo.enable = m_Vibrate;
		alarmInfo.repeat = lblRepeat.text;
		alarmInfo.sound = selectSound;
        NSLog(@"alarmInfo.sound111-> %d", alarmInfo.sound);
		alarmInfo.message = strMessage;
        NSLog(@"message -> %@", alarmInfo.message);
//        [timePicker minute];
//		int hour = [timePicker hour];
//        int minute = [timePicker minute];
//
//		alarmInfo.hour = [timePicker hour];
//		alarmInfo.minute = [timePicker minute];
//		alarmInfo.am = (alarmInfo.hour<12?0:1);
		NSLog(@"%d", alarmInfo.am);
        NSLog(@"%d", alarmInfo.hour);
		[Database updateAlarmInfo:alarmInfo];
		[Database scheduleAlarmNotification];
	}
}

- (void)done:(UIBarButtonItem *)sender
{
    AlarmAndClockAppDelegate *delegate = (AlarmAndClockAppDelegate*)[[UIApplication sharedApplication] delegate];
//    if (delegate.m_DisplayRepeatStatus == FALSE){
//        UIAlertView *alertRepeat = [[UIAlertView alloc] initWithTitle:@"Alert!" message:@"Please set the Repeat" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//        [alertRepeat show];
//        [alertRepeat release];
//        return;
//    }
//    if (delegate.m_DisplaySoundStatus == FALSE){
//        UIAlertView *alertSound = [[UIAlertView alloc] initWithTitle:@"Alert!" message:@"Please set the Alarm Sound" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//        [alertSound show];
//        [alertSound release];
//        return;
//    }
    if (delegate.m_DisplayStartTimeStatus == FALSE){
        UIAlertView *alertStart = [[UIAlertView alloc] initWithTitle:@"Alert!" message:@"Please set the Start Time" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertStart show];
        [alertStart release];
        return;
    }
    if (delegate.m_DisplayEndTimeStatus == FALSE){
        UIAlertView *alertEnd = [[UIAlertView alloc] initWithTitle:@"Alert!" message:@"Please set the End Time" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertEnd show];
        [alertEnd release];
        return;
    }
    if (delegate.m_DisplayIntervalStatus == FALSE){
        UIAlertView *alertInterval = [[UIAlertView alloc] initWithTitle:@"Alert!" message:@"Please set the Interval Time" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertInterval show];
        [alertInterval release];
        return;
    }

    
    double time = [delegate.endTime timeIntervalSinceDate:delegate.startTime];
//    double interval = [delegate.intervalHour doubleValue] * 3600 + [delegate.intervalMin doubleValue] * 60;
    double interval = delegate.intervalHour * 3600 + delegate.intervalMin * 60;
    int nNotfi = (int)(time / interval);
    
    NSLog(@"number of notifications = %d", nNotfi);
    NSLog(@"interval %e", time);
    
    for(int i=0; i<nNotfi; i++)
    {
		AlarmInfo* alarmInfo = [[AlarmInfo alloc] init];
		alarmInfo.id_value = [NSString stringWithFormat:@"%d", (int)[[NSDate date] timeIntervalSince1970]];
		alarmInfo.enable = m_Vibrate;

        if( [[delegate.startTime dateByAddingTimeInterval:i*interval] timeIntervalSinceDate:delegate.endTime] >= -45)
            break;
        
		NSDate* now = [self dateToGMT:[delegate.startTime dateByAddingTimeInterval:i*interval]];
        NSLog(@"%d notification date :: %@", i, [now description]);
		NSString* dateString = [now description];
		NSArray* arr1 = [dateString componentsSeparatedByString:@" "];
		NSString* time = (NSString*)[arr1 objectAtIndex:1];
		NSArray* arr2 = [time componentsSeparatedByString:@":"];
		NSString* sHour = (NSString*)[arr2 objectAtIndex:0];
		NSString* sMinute = (NSString*)[arr2 objectAtIndex:1];
        
        alarmInfo.hour = [sHour intValue];
        alarmInfo.minute = [sMinute intValue];
		alarmInfo.am = (alarmInfo.hour<12?0:1);
        NSLog(@"alarmInfor.hour minute -> %d %d", alarmInfo.hour, alarmInfo.minute);
        
        alarmInfo.sound = selectSound;
        NSLog(@"select sound -> %d", selectSound);
		alarmInfo.repeat = strRepeat;
		alarmInfo.message = self.strMessage;
        alarmInfo.volume = 50;
        
		[Database addAlarmInfo:alarmInfo];
		[Database scheduleAlarmNotification];
		[alarmInfo release];		
    }
    
////////////////////////// Set the EndTime Alarm 
    AlarmInfo* alarmInfo = [[AlarmInfo alloc] init];
    alarmInfo.id_value = [NSString stringWithFormat:@"%d", (int)[[NSDate date] timeIntervalSince1970]];
    alarmInfo.enable = m_Vibrate;
	
    NSDate* now = [self dateToGMT:delegate.endTime];
    NSString* dateString = [now description];
    NSArray* arr1 = [dateString componentsSeparatedByString:@" "];
    NSString* endtime = (NSString*)[arr1 objectAtIndex:1];
    NSArray* arr2 = [endtime componentsSeparatedByString:@":"];
    NSString* sHour = (NSString*)[arr2 objectAtIndex:0];
    NSString* sMinute = (NSString*)[arr2 objectAtIndex:1];
	
    alarmInfo.hour = [sHour intValue];
    alarmInfo.minute = [sMinute intValue];
    alarmInfo.am = (alarmInfo.hour<12?0:1);
	
    alarmInfo.sound = selectSound;
    alarmInfo.repeat = strRepeat;
    alarmInfo.message = self.strMessage;
    alarmInfo.volume = 50;
    
    [Database addAlarmInfo:alarmInfo];
    [Database scheduleAlarmNotification];
    [alarmInfo release];
    
////////////////////////    
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) enableAlarm:(UISwitch *)sender
{
	m_Vibrate = sender.on;
}

-(void) tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
	[tlbView deselectRowAtIndexPath:indexPath animated:YES];
	if (indexPath.row == 1) 
    {
        if (nSelectAlarm == -1)
            [self viewWillDisappear:NO];
		RepeatAlarmViewController* repeat = [[[RepeatAlarmViewController alloc] init] autorelease];
		repeat.nSelectAlarm = nSelectAlarm;
		[self.navigationController pushViewController:repeat animated:YES];
	}
	if (indexPath.row == 2) 
    {
        if (nSelectAlarm == -1)
            [self viewWillDisappear:NO];
		SoundMusicViewController* sound = [[[SoundMusicViewController alloc] init] autorelease];
		sound.nSelectAlarm = nSelectAlarm;
		[self.navigationController pushViewController:sound animated:YES];
	}
//    if (indexPath.row == 4) 
//    {
//        if (nSelectAlarm == -1)
//            [self viewWillDisappear:NO];
//        SnoozeSettingController *controller = [[[SnoozeSettingController alloc] init] autorelease];
//        controller.selectAlarmNo = nSelectAlarm;
//        [self.navigationController pushViewController:controller animated:YES];
//    }
    //G.W.
    if (indexPath.row == 4)
    {
        if (nSelectAlarm == -1)
            [self viewWillDisappear:NO];
        StartTimerViewController *startTimerView = [[StartTimerViewController alloc]init];
        [self.navigationController pushViewController:startTimerView animated:YES];
    }
    if (indexPath.row == 5)
    {
        if (nSelectAlarm == -1)
            [self viewWillDisappear:NO];
        EndTimeViewController *endTimerView = [[EndTimeViewController alloc]init];
        [self.navigationController pushViewController:endTimerView animated:YES];
    }
    if (indexPath.row == 6){
        if (nSelectAlarm == -1)
            [self viewWillDisappear:NO];
        IntervalTimeViewController *intervalView = [[IntervalTimeViewController alloc]init];
        [self.navigationController pushViewController:intervalView animated:YES];
    }
    
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AlarmAndClockAppDelegate *delegate = (AlarmAndClockAppDelegate*)[[UIApplication sharedApplication] delegate];
    
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:nil] autorelease];
	}
	
	NSArray* views = [cell.contentView subviews];
	for (UIView* subView in views) {
		[subView removeFromSuperview];
	}
//G.W.
	if (indexPath.row == 0) {
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		UILabel *label=[[[UILabel alloc]init] autorelease];
		label.backgroundColor = [UIColor clearColor];
		label.textColor = [UIColor blackColor];
		label.frame=CGRectMake(15, 0, 150, 40);
		label.font = [UIFont boldSystemFontOfSize:15];
        //G.W.
		label.text= @"Vibrate";
		[cell.contentView addSubview:label];
		
		UISwitch* onOff = [[[UISwitch alloc] initWithFrame:CGRectMake(180, 7, 60, 40)] autorelease];
		[onOff setOn:m_Vibrate animated:YES];
		[onOff addTarget:self action:@selector(enableAlarm:) forControlEvents:UIControlEventValueChanged];
		[cell.contentView addSubview:onOff];

	}
	if (indexPath.row == 1) {
		cell.selectionStyle = UITableViewCellSelectionStyleBlue;
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		UILabel *label=[[[UILabel alloc]init] autorelease];
		label.backgroundColor = [UIColor clearColor];
		label.textColor = [UIColor blackColor];
		label.frame=CGRectMake(15, 0, 80, 40);
		label.font = [UIFont boldSystemFontOfSize:15];
		label.text= @"Repeat";
		[cell.contentView addSubview:label];

		
		lblRepeat = [[UILabel alloc]init];
		lblRepeat.backgroundColor = [UIColor clearColor];
		lblRepeat.textColor = [UIColor grayColor];
		lblRepeat.frame=CGRectMake(85, 0, 170, 40);
		lblRepeat.font = [UIFont systemFontOfSize:13];
		lblRepeat.textAlignment = UITextAlignmentRight;
		lblRepeat.text= strRepeat;
		[cell.contentView addSubview:lblRepeat];
	}
	if (indexPath.row == 2) {
		cell.selectionStyle = UITableViewCellSelectionStyleBlue;
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		UILabel *label=[[[UILabel alloc]init] autorelease];
		label.backgroundColor = [UIColor clearColor];
		label.textColor = [UIColor blackColor];
		label.frame=CGRectMake(15, 0, 150, 40);
		label.font = [UIFont boldSystemFontOfSize:15];
		label.text= @"Sound & Music";
		[cell.contentView addSubview:label];
	}
	if (indexPath.row == 3) {
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		UILabel *label=[[[UILabel alloc]init] autorelease];
		label.backgroundColor = [UIColor clearColor];
		label.textColor = [UIColor blackColor];
		label.frame=CGRectMake(15, 0, 70, 40);
		label.font = [UIFont boldSystemFontOfSize:15];
		label.text= @"Message";
		[cell.contentView addSubview:label];
		
		msgTextField = [[UITextField alloc] initWithFrame:CGRectMake(85, 0, 200, 40)];
		[msgTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
		msgTextField.borderStyle = UITextBorderStyleNone;
		msgTextField.placeholder = @"Add your message here";
		msgTextField.text = self.strMessage;
		msgTextField.textColor = [UIColor darkGrayColor];
		msgTextField.font = [UIFont systemFontOfSize:14];
		[msgTextField setBackgroundColor:[UIColor clearColor]];
		msgTextField.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
		msgTextField.keyboardType = UIKeyboardTypeEmailAddress; // use the default type input method (entire keyboard)
		msgTextField.returnKeyType = UIReturnKeyDefault;
		msgTextField.delegate = self;
		msgTextField.clearButtonMode = UITextFieldViewModeWhileEditing; // has a clear 'x' button to the right
		[cell.contentView addSubview:msgTextField];
	}

    //G.W.
    if (indexPath.row == 4){
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.frame = CGRectMake(15, 0, 150, 40);
        label.font = [UIFont boldSystemFontOfSize:15];
        label.text = @"Start Time";
        [cell.contentView addSubview:label];
        
        lblRepeat1 = [[UILabel alloc]init];
		lblRepeat1.backgroundColor = [UIColor clearColor];
		lblRepeat1.textColor = [UIColor grayColor];
		lblRepeat1.frame=CGRectMake(85, 0, 170, 40);
		lblRepeat1.font = [UIFont systemFontOfSize:13];
		lblRepeat1.textAlignment = UITextAlignmentRight;
        //G.W.06/26/2012
//        NSDate* now = [self dateToGMT:self.timePicker.date];
//		lblRepeat1.text= [delegate.startTime description];
//        NSLog(@"lblRepeat1.text->%@", [delegate.startTime description]);
        AlarmAndClockAppDelegate *delegate = (AlarmAndClockAppDelegate*)[[UIApplication sharedApplication] delegate];
        lblRepeat1.text= [NSString stringWithFormat:@"%02d:%02d %@", (delegate.startHour<12?delegate.startHour:delegate.startHour-12), delegate.startMinute, (delegate.startHour<12?@"AM":@"PM")];	
		[cell.contentView addSubview:lblRepeat1];
    }
    if (indexPath.row == 5){
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.frame = CGRectMake(15, 0, 150, 40);
        label.font = [UIFont boldSystemFontOfSize:15];
        label.text = @"End Time";
        [cell.contentView addSubview:label];
        
        lblRepeat2 = [[UILabel alloc]init];
		lblRepeat2.backgroundColor = [UIColor clearColor];
		lblRepeat2.textColor = [UIColor grayColor];
		lblRepeat2.frame=CGRectMake(85, 0, 170, 40);
		lblRepeat2.font = [UIFont systemFontOfSize:13];
		lblRepeat2.textAlignment = UITextAlignmentRight;
//		lblRepeat2.text= [delegate.endTime description];
        AlarmAndClockAppDelegate *delegate = (AlarmAndClockAppDelegate*)[[UIApplication sharedApplication] delegate];
        lblRepeat2.text= [NSString stringWithFormat:@"%02d:%02d %@", (delegate.endHour<12?delegate.endHour:delegate.endHour-12), delegate.endMinute, (delegate.endHour<12?@"AM":@"PM")];	
		[cell.contentView addSubview:lblRepeat2];
    }
    if (indexPath.row == 6){
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.frame = CGRectMake(15, 0, 150, 40);
        label.font = [UIFont boldSystemFontOfSize:15];
        label.text = @"Interval Time";
        [cell.contentView addSubview:label];
        
        lblRepeat3 = [[UILabel alloc]init];
		lblRepeat3.backgroundColor = [UIColor clearColor];
		lblRepeat3.textColor = [UIColor grayColor];
		lblRepeat3.frame=CGRectMake(85, 0, 170, 40);
		lblRepeat3.font = [UIFont systemFontOfSize:13];
		lblRepeat3.textAlignment = UITextAlignmentRight;
//		lblRepeat3.text= [NSString stringWithFormat:@"%@ : %@",  delegate.intervalHour, delegate.intervalMin];
        lblRepeat3.text = [NSString stringWithFormat:@"%02d:%02d", delegate.intervalHour, delegate.intervalMin];
		[cell.contentView addSubview:lblRepeat3];
    }
    
	return cell;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
	[msgTextField resignFirstResponder];
	return YES;
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait) || (UIInterfaceOrientationPortraitUpsideDown == UIInterfaceOrientationLandscapeRight);
}

- (IBAction)toogleOnForSwitch:(id)sender{
    AlarmAndClockAppDelegate *delegate = (AlarmAndClockAppDelegate*)[[UIApplication sharedApplication] delegate];
    if (btn_vibrate.on)
        delegate.vibrateState = YES;
    else 
        delegate.vibrateState = NO;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [btn_vibrate release];
    btn_vibrate = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[tlbView release];
	[doneBt release];
	[timePicker release];
    [btn_vibrate release];
    [super dealloc];
}


@end
