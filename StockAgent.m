//
//  StockAgent.m
//  AlarmAndClock
//
//  Created by Alexandr on 11/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StockAgent.h"


@implementation StockAgent
@synthesize httpClient, delegate;
@synthesize stockSymbolArray, stockNameDictionary, stockItemArray;
static StockAgent *_sharedAgent;

+ (StockAgent *)sharedStockAgent {
	if (_sharedAgent == nil)
	{
		_sharedAgent = [[StockAgent alloc] init];
	}
	return _sharedAgent;
}
+ (void)releaseSharedStockAgent
{
	if (_sharedAgent)
		[_sharedAgent release];
}

- (StockAgent *) init {
	self = [super init];
	if (self)
	{
		self.httpClient = [[HttpClient alloc] init];
		self.httpClient.delegate = self;
		delegate = nil;
		
		self.stockSymbolArray = [NSArray arrayWithObjects:@"INDEXDJX:.DJI", @"INDEXSP:.INX", @"INDEXNASDAQ:.IXIC", @"TPE:TAIEX", 
								 @"INDEXFTSE:UKX", @"INDEXSTOXX:SX5E", @"INDEXEURO:PX1", 
								 @"TSE:OSPTX", @"INDEXASX:XJO", @"INDEXBOM:SENSEX", @"SHA:000001", @"INDEXNIKKEI:NI225", @"INDEXHANGSENG:HSI", nil];
		self.stockNameDictionary = [NSMutableDictionary dictionary];
		[self.stockNameDictionary setValue:@"Dow Jones" forKey:@"INDEXDJX:.DJI"];
		[self.stockNameDictionary setValue:@"S&P 500" forKey:@"INDEXSP:.INX"];
		[self.stockNameDictionary setValue:@"Nasdaq" forKey:@"INDEXNASDAQ:.IXIC"];
		[self.stockNameDictionary setValue:@"TSEC" forKey:@"TPE:TAIEX"];
		[self.stockNameDictionary setValue:@"FTSE" forKey:@"INDEXFTSE:UKX"];
		[self.stockNameDictionary setValue:@"STOXX" forKey:@"INDEXSTOXX:SX5E"];
		[self.stockNameDictionary setValue:@"CAC 40" forKey:@"INDEXEURO:PX1"];
		[self.stockNameDictionary setValue:@"S&P/TSX" forKey:@"TSE:OSPTX"];
		[self.stockNameDictionary setValue:@"S&P/ASX" forKey:@"INDEXASX:XJO"];
		[self.stockNameDictionary setValue:@"BSE Senex" forKey:@"INDEXBOM:SENSEX"];
		[self.stockNameDictionary setValue:@"Shanghai" forKey:@"SHA:000001"];
		[self.stockNameDictionary setValue:@"NIKKEI" forKey:@"INDEXNIKKEI:NI225"];
		[self.stockNameDictionary setValue:@"HangSeng" forKey:@"INDEXHANGSENG:HSI"];
	}
	return self;
}

- (void) requestStock{
	[httpClient cancel];
	[httpClient reqStock];
}
#pragma mark DDHttpClientDelegate
- (void)HttpClientSucceeded:(HttpClient*)sender
{
	NSArray *result = sender.result;
	self.stockItemArray = result;
	if ([stockItemArray count] > 0)
	{
		[delegate didChangeStock];
	}
	
}

- (StockItem *)stockItemForSymbol:(NSString *)symbol {
	StockItem *item = nil;
	if ([stockItemArray count] == 0)
		return nil;
	
	for (item in stockItemArray) {
		NSArray *arrTemp = [symbol componentsSeparatedByString:@":"];
		NSString *ticker = [arrTemp objectAtIndex:1];
		if ([item.tickerSymbol isEqualToString:ticker])
			return item;
	}
	return nil;
}

- (NSString *)nextStockSymbol:(NSString *)symbol
{
    int countSymbol = [stockSymbolArray count];
    for (int i = 0; i < countSymbol; i++)
    {
        NSString *curSymbol = [stockSymbolArray objectAtIndex:i];
        if ([curSymbol isEqualToString:symbol])
            return [stockSymbolArray objectAtIndex:((i+1)%countSymbol)]; 
    }
    return nil;
}
- (void)HttpClientFailed:(HttpClient*)sender {
}

- (void) dealloc {
	[stockNameDictionary release];
	[stockSymbolArray release];
	[stockItemArray release];
	[httpClient release];
	[super dealloc];
}

@end
