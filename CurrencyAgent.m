//
//  CurrencyAgent.m
//  AlarmAndClock
//
//  Created by Alexandr on 11/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CurrencyAgent.h"
#import "Database.h"

@implementation CurrencyAgent
@synthesize httpClient, delegate;
@synthesize currencyNameArray, loadedCurrencyItem;

static CurrencyAgent * _sharedAgent;

+ (CurrencyAgent *)sharedCurrencyAgent {
	if (_sharedAgent == nil)
	{
		_sharedAgent = [[CurrencyAgent alloc] init];
	}
	return _sharedAgent;
}
+ (void)releaseSharedCurrencyAgent
{
	if (_sharedAgent)
		[_sharedAgent release];
}

- (CurrencyAgent *) init {
	self = [super init];
	if (self)
	{
		self.httpClient = [[HttpClient alloc] init];
		self.httpClient.delegate = self;
		self.currencyNameArray = [NSArray arrayWithObjects:@"EUR/USD", @"USD/JPY", @"GBP/USD", @"USD/CAD", @"USD/HKD", @"USD/CNY", @"AUD/USD", nil];
		loadedCurrencyItem = nil;
		delegate = nil;
	}
	return self;
}

- (void) requestCurrency {
	[httpClient cancel];
	[httpClient reqCurrency];
}
#pragma mark DDHttpClientDelegate
- (void)HttpClientSucceeded:(HttpClient*)sender
{
	NSArray *result = sender.result;
	CurrencyItem *item = nil;
	if ([result count] > 0)
		item = [result objectAtIndex:0];
	if (item != nil)
	{
		self.loadedCurrencyItem = item;
		[delegate didChangeCurrency:item];
		NSLog(@"Currency received - %f, %f, %f, %f", item.eur, item.usd, item.cny, item.jpy);
	}
	
}


- (void)HttpClientFailed:(HttpClient*)sender {
}

- (void) dealloc {
	[httpClient release];
	[loadedCurrencyItem release];
	[[CurrencyAgent sharedCurrencyAgent].currencyNameArray release];
	[super dealloc];
}
@end
