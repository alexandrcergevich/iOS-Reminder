//
//  InfoMainController.m
//  AlarmAndClock
//
//  Created by Alexandr on 1/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InfoMainController.h"
#import "AboutViewController.h"
#import "HelpViewController.h"
#import "ClockViewController.h"
#define BUTTONCOLOR [UIColor colorWithRed:6.0/255.0 green:214.0/255.0 blue:254.0/255.0 alpha:1.0]
@implementation InfoMainController
@synthesize vcHelp, vcAbout, btnHelp, btnAbout, vwContainer;
#pragma mark - Initialize
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.vcAbout = [[[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil] autorelease];
    self.vcHelp = [[[HelpViewController alloc] initWithNibName:@"HelpViewController" bundle:nil] autorelease];
    [vwContainer addSubview:vcAbout.view];
    state = STATE_ABOUT;
    [btnAbout setTitleColor:BUTTONCOLOR forState:UIControlStateNormal];
    [btnAbout setTitleColor:BUTTONCOLOR forState:UIControlStateHighlighted];
    [btnHelp setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnHelp setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)aboutButtonPressed:(id)sender
{
    if (state == STATE_ABOUT)
        return;
    [btnAbout setTitleColor:BUTTONCOLOR forState:UIControlStateNormal];
    [btnAbout setTitleColor:BUTTONCOLOR forState:UIControlStateHighlighted];
    [btnHelp setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnHelp setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [vcHelp.view removeFromSuperview];
    [vwContainer addSubview:vcAbout.view];
    state = STATE_ABOUT;
}
- (IBAction)helpButtonPressed:(id)sender
{
    if (state == STATE_HELP)
        return;
    [btnHelp setTitleColor:BUTTONCOLOR forState:UIControlStateNormal];
    [btnHelp setTitleColor:BUTTONCOLOR forState:UIControlStateHighlighted];
    [btnAbout setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnAbout setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [vcAbout.view removeFromSuperview];
    [vwContainer addSubview:vcHelp.view];
    state = STATE_HELP;
}

- (IBAction)backButtonPressed:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}
#pragma mark - Dealloc
- (void)dealloc
{
    [vcHelp release];
    [vcAbout release];
    [btnHelp release];
    [btnAbout release];
    [vwContainer release];
    [super dealloc];
}
@end
