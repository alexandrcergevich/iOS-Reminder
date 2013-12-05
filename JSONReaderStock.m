//
//  JSONReaderStock.m
//  AlarmAndClock
//
//  Created by Alexandr on 11/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JSONReaderStock.h"
#import "JSON.h"
#import "StockItem.h"

@implementation JSONReaderStock 
@synthesize itemArray;

- (id) init {
	if (self = [super init])
	{
		self.itemArray = [NSMutableArray arrayWithCapacity:5];
	}
	return self;
}
- (void) parseJSONWithData:(NSData *)data {

	
	NSData *correctData = [data subdataWithRange:NSMakeRange(3, [data length] - 3)];
	NSString *parsingString = [NSString stringWithCString:[correctData bytes]];
	
	NSArray *result = [parsingString JSONValue];
	if ([result isKindOfClass:[NSArray class]])
	{
		
		if ([result count] == 0)
			return;
		for (NSDictionary *itemDictionary in result)
		{
			StockItem *item = [[StockItem alloc] init];
			item.tickerSymbol = [itemDictionary objectForKey:@"t"];
			item.stockValue = [itemDictionary objectForKey:@"l"];
			item.changeValue = [itemDictionary objectForKey:@"c"];
			item.changePercent = [itemDictionary objectForKey:@"cp"];
			/*
			NSEnumerator *e = [itemDictionary keyEnumerator];
			NSString *key;
			while ((key = [e nextObject]))
			{
				NSString *val = [itemDictionary objectForKey:key];
				NSLog(@"%@  %@", key, val);
			}
			 */
			NSLog(@"Fetched Data - %@, %@, %@, %@", item.tickerSymbol, item.stockValue, item.changeValue, item.changePercent);
			[itemArray addObject:item];
	
		}
	}
}

- (void) dealloc {
	[itemArray release];
	[super dealloc];
}

@end
