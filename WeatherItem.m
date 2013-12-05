//
//  WeatherItem.m
//  AlarmAndClock
//
//  Created by Alexandr on 11/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WeatherItem.h"

@implementation WeatherItem
@synthesize unitTemperature, unitDistance, unitPressure, unitSpeed;
@synthesize windSpeed, condition, code, temperature;

- (void)dealloc {
	[unitTemperature release];
	[unitDistance release];
	[unitPressure release];
	[unitSpeed release];
	[windSpeed release];
	[condition release];
	[code release];
	[temperature release];
	[super dealloc];
}
@end
