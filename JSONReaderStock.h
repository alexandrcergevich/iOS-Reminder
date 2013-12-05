//
//  JSONReaderStock.h
//  AlarmAndClock
//
//  Created by Alexandr on 11/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JSONReaderStock : NSObject {

	NSMutableArray *itemArray;
}
@property (nonatomic, retain) NSMutableArray *itemArray;
- (void)parseJSONWithData:(NSData*)data;

@end