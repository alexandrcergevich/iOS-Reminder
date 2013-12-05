//
//  StockInfo.h
//  AlarmAndClock
//
//  Created by Alexandr on 11/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface StockItem : NSObject {

}
@property (nonatomic, copy) NSString *tickerSymbol;
@property (nonatomic, copy) NSString *stockValue;
@property (nonatomic, copy) NSString *changeValue;
@property (nonatomic, copy) NSString *changePercent;

@end
