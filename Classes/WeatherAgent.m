//
//  WeatherAgent.m
//  AlarmAndClock
//
//  Created by Alexandr on 11/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WeatherAgent.h"


@implementation WeatherAgent
@synthesize httpClient, delegate, weatherItem;

static WeatherAgent * _sharedAgent;

+ (WeatherAgent *)sharedWeatherAgent {
	if (_sharedAgent == nil)
	{
		_sharedAgent = [[WeatherAgent alloc] init];
	}
	return _sharedAgent;
}
+ (void)releaseSharedWeatherAgent
{
	if (_sharedAgent)
		[_sharedAgent release];
}

- (WeatherAgent *) init {
	self = [super init];
	if (self)
	{
		self.httpClient = [[HttpClient alloc] init];
		self.httpClient.delegate = self;
		self.weatherItem = nil;
		delegate = nil;
	}
	return self;
}

- (void) requestWeatherWithWoeID:(NSString *)woeID andUnit:(int)unit {
	[httpClient cancel];
	[httpClient reqWeatherByWoeID:woeID andUnit:unit];
}
#pragma mark DDHttpClientDelegate
- (void)HttpClientSucceeded:(HttpClient*)sender
{
	NSArray *result = sender.result;
	WeatherItem *item = nil;
	if ([result count] > 0)
		item = [result objectAtIndex:0];
	if (item != nil)
	{
        if (item.condition == nil || item.code == nil || item.windSpeed == nil || item.temperature == nil)
            return;
		[delegate didChangeWeather:item];
		NSLog(@"Weather received - %@, %@, %@, %@", item.condition, item.code, item.windSpeed, item.temperature);
		self.weatherItem = item;
	}
	
}

- (void)HttpClientFailed:(HttpClient*)sender {
}

- (void) dealloc {
	[weatherItem release];
	[httpClient release];
	[super dealloc];
}
@end
