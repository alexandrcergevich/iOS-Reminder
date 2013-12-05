//
//  XMLReaderCurrency.h
//  AlarmAndClock
//
//  Created by Alexandr on 11/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CurrencyItem.h"

@interface XMLReaderCurrency : NSObject <NSXMLParserDelegate>{
	CurrencyItem *currentItem;
	NSMutableArray *itemArray;
	NSMutableString *contentOfCuttentBlock;
}

@property (nonatomic, retain) NSMutableArray *itemArray;
@property (nonatomic, retain) NSMutableString *contentOfCurrentBlock;
@property (nonatomic, retain) CurrencyItem *currentItem;
@property (nonatomic) int totalCount;

- (void)parseXMLWithData:(NSData *)data parseError:(NSError **)error;

@end
