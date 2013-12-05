//
//  XMLReaderPlace.h
//  AlarmAndClock
//
//  Created by Alexandr on 11/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlaceItem.h"

@interface XMLReaderPlace : NSObject <NSXMLParserDelegate>{
	PlaceItem *currentItem;
	NSMutableArray *itemArray;
	NSMutableString *contentOfCuttentBlock;
	BOOL isFirstGeoPoint;
}

@property (nonatomic, retain) NSMutableArray *itemArray;
@property (nonatomic, retain) NSMutableString *contentOfCurrentBlock;
@property (nonatomic, retain) PlaceItem *currentItem;
@property (nonatomic) int totalCount;

- (void)parseXMLWithData:(NSData *)data parseError:(NSError **)error;
- (void)parseXMLFileAtURL:(NSURL *)url parseError:(NSError **)error;
@end
