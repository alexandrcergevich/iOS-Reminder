//
//  StockInfo.m
//  AlarmAndClock
//
//  Created by Alexandr on 11/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StockItem.h"


@implementation StockItem
@synthesize tickerSymbol, stockValue, changeValue, changePercent;


- (void)dealloc {
	[tickerSymbol release];
	[stockValue release];
	[changeValue release];
	[changePercent release];
	[super dealloc];
}
@end
