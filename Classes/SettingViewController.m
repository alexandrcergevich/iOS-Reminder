//
//  SettingViewController.m
//  AlarmAndClock
//
//  Created by Alexandr on 10/31/11.
//  Copyright 2011 12345. All rights reserved.
//

#import "SettingViewController.h"
#import "AlarmlistViewController.h"
#import "DisplayViewController.h"
#import "SleepViewController.h"
#import "AdvancedViewController.h"
@implementation SettingViewController

@synthesize tlbView;
@synthesize doneBt;

- (void)viewDidLoad
{
	doneBt = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction:)];
	
	self.navigationItem.rightBarButtonItem = doneBt;
	self.navigationItem.title = @"Settings";
}

- (void) doneAction:(id)sender
{
	[self dismissModalViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tlbView deselectRowAtIndexPath:indexPath animated:YES];
	
	if (indexPath.row == 0) {
		AlarmlistViewController* alarmlist = [[[AlarmlistViewController alloc] init] autorelease];
		[self.navigationController pushViewController:alarmlist animated:YES];
	}
	if (indexPath.row == 1) {
		SleepViewController *sleepController = [[[SleepViewController alloc] init] autorelease];
		[self.navigationController pushViewController:sleepController animated:YES];
	}
	if (indexPath.row == 2) {
		DisplayViewController* display = [[[DisplayViewController alloc] init] autorelease];
		[self.navigationController pushViewController:display animated:YES];
	}
	if (indexPath.row == 3) {
		AdvancedViewController *advanced = [[[AdvancedViewController alloc] init] autorelease];
		[self.navigationController pushViewController:advanced animated:YES];
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//	return 2;
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:nil] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.selectionStyle = UITableViewCellSelectionStyleBlue;
	}
	
	NSArray* views = [cell.contentView subviews];
	for (UIView* subView in views) {
		[subView removeFromSuperview];
	}
	
	if (indexPath.row == 0) {
		UILabel *label=[[UILabel alloc]init];
		label.backgroundColor = [UIColor clearColor];
		label.textColor = [UIColor blackColor];
		label.frame=CGRectMake(70, 0, 190, 40);
		label.font = [UIFont fontWithName:@"Verdana" size:17];
		label.numberOfLines = 0;
//		label.text= @"Alarms";
        label.text= @"Reminder";
		[cell.contentView addSubview:label];
		[label release];
        UIImageView *image = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"alarm_icon.png"]] autorelease];
        image.frame = CGRectMake(30, 10, 28, 21);
        [cell.contentView addSubview:image];
	}
	if (indexPath.row == 1) {
		UILabel *label=[[UILabel alloc]init];
		label.backgroundColor = [UIColor clearColor];
		label.textColor = [UIColor blackColor];
		label.frame=CGRectMake(70, 0, 190, 40);
		label.font = [UIFont fontWithName:@"Verdana" size:17];
		label.numberOfLines = 0;
        //G.W. 6/16/2012
		label.text= @"Custom Timer";
		[cell.contentView addSubview:label];
		[label release];
        UIImageView *image = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sleeper.png"]] autorelease];
        image.frame = CGRectMake(30, 10, 28, 21);
        [cell.contentView addSubview:image];
	}
	if (indexPath.row == 2) {
		UILabel *label=[[UILabel alloc]init];
		label.backgroundColor = [UIColor clearColor];
		label.textColor = [UIColor blackColor];
		label.frame=CGRectMake(70, 0, 190, 40);
		label.font = [UIFont fontWithName:@"Verdana" size:17];
		label.numberOfLines = 0;
		label.text= @"Display";
		[cell.contentView addSubview:label];
		[label release];
        UIImageView *image = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"display_icon.png"]] autorelease];
        image.frame = CGRectMake(30, 10, 28, 21);
        [cell.contentView addSubview:image];
	}
	if (indexPath.row == 3) {
		UILabel *label=[[UILabel alloc]init];
		label.backgroundColor = [UIColor clearColor];
		label.textColor = [UIColor blackColor];
		label.frame=CGRectMake(70, 0, 190, 40);
		label.font = [UIFont fontWithName:@"Verdana" size:17];
		label.numberOfLines = 0;
		label.text= @"Advanced";
		[cell.contentView addSubview:label];
		[label release];
        UIImageView *image = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"setting_icon.png"]] autorelease];
        image.frame = CGRectMake(30, 10, 28, 21);
        [cell.contentView addSubview:image];
	}
	
	return cell;
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait) || (UIInterfaceOrientationPortraitUpsideDown == UIInterfaceOrientationLandscapeRight);
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[doneBt release];
	[tlbView release];
    [super dealloc];
}


@end
