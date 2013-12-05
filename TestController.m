//
//  TestController.m
//  AlarmAndClock
//
//  Created by Alexandr on 11/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TestController.h"


@implementation TestController

@synthesize imgWordBackground, imgWordClockBackground;
@synthesize lblWordHour, lblWordMinute, lblWordSecond, lblWordMorning;
@synthesize lblWordYear, lblWordMonth, lblWordDay, lblWordWeekday;
@synthesize lblWordHourCaption, lblWordMinuteCaption, lblWordSecondCaption;
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	NSArray *familyNames = [UIFont familyNames];
	
	for (NSString *familyName in familyNames) {
		NSLog(@"Family: %@ \n", familyName);
		
		NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];
		
		for (NSString *fontName in fontNames) {
			NSLog (@"\tFont: %@ \n", fontName);
		}
	}
	
	[self setWordClock];

}

- (void) setWordClock {
	[lblWordHour setFont:[UIFont fontWithName:@"AEnigmaScrawl4BRK" size:40]];
	[lblWordMinute setFont:[UIFont fontWithName:@"AEnigmaScrawl4BRK" size:40]];
	[lblWordSecond setFont:[UIFont fontWithName:@"AEnigmaScrawl4BRK" size:40]];
	
	[lblWordSecondCaption setFont:[UIFont fontWithName:@"AEnigmaScrawl4BRK" size:24]];
	[lblWordMinuteCaption setFont:[UIFont fontWithName:@"AEnigmaScrawl4BRK" size:24]];
	[lblWordHourCaption setFont:[UIFont fontWithName:@"AEnigmaScrawl4BRK" size:24]];
	[lblWordMorning setFont:[UIFont fontWithName:@"AEnigmaScrawl4BRK" size:24]];
	
	[lblWordYear setFont:[UIFont fontWithName:@"AEnigmaScrawl4BRK" size:24]];
	[lblWordMonth setFont:[UIFont fontWithName:@"AEnigmaScrawl4BRK" size:24]];
	[lblWordDay setFont:[UIFont fontWithName:@"AEnigmaScrawl4BRK" size:24]];
	[lblWordWeekday setFont:[UIFont fontWithName:@"AEnigmaScrawl4BRK" size:24]];
	
	
}
- (void) setClockDigitsColor:(UIColor *)color {
	
}




// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return YES;
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
	[imgWordBackground release];
	[imgWordClockBackground release];
	[lblWordHour release];
	[lblWordMinute release];
	[lblWordSecond release];
	[lblWordMorning release];
	[lblWordYear release];
	[lblWordMonth release];
	[lblWordDay release];
	[lblWordWeekday release];
	[lblWordHourCaption release];
	[lblWordMinuteCaption release];
	[lblWordSecondCaption release];
}


@end
