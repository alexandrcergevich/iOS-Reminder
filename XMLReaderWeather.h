//
//  XMLReaderWeather.h
//  AlarmAndClock
//
//  Created by Alexandr on 11/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherItem.h"

@interface XMLReaderWeather : NSObject <NSXMLParserDelegate> {

	WeatherItem *currentItem;
	NSMutableArray *itemArray;
	NSMutableString *contentOfCurrentBlock;
}

@property (nonatomic, retain) NSMutableArray *itemArray;
@property (nonatomic, retain) WeatherItem *currentItem;
@property (nonatomic, retain) NSMutableString *contentOfCurrentBlock;
@property (nonatomic) int totalCount;

- (void)parseXMLWithData:(NSData *)data parseError:(NSError **)error;
- (void)parseXMLFileAtURL:(NSURL *)url parseError:(NSError **)error;
@end
