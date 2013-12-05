//
//  customnavigator.m
//  Photo Objects
//
//  Created by Alex on 10/20/12.
//  Copyright (c) 2012 Alexandr. All rights reserved.
//

#import "customnavigator.h"
#import "AlarmAndClockAppDelegate.h"
#import "infoceViewController.h"

@interface customnavigator ()

@end

@implementation customnavigator
@synthesize currentView;

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotate
{
    currentView = [AlarmAndClockAppDelegate sharedAppDelegate].tempView;
    if ([currentView isKindOfClass:[infoceViewController class]]){
        return NO;
    }
    return YES;
    
}

-(NSUInteger)supportedInterfaceOrientations
{
    return [[self.viewControllers lastObject] supportedInterfaceOrientations];
}

//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
//{
//    return [[self.viewControllers lastObject] preferredInterfaceOrientationForPresentation];
//}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
	return YES;
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//- (void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
//    NSLog(@"orientation %d", toInterfaceOrientation);
//    
//}

@end
