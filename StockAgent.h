//
//  StockAgent.h
//  AlarmAndClock
//
//  Created by Alexandr on 11/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpClient.h"
#import "JSONReaderStock.h"
#import "StockItem.h"

@protocol StockAgentDelegate
- (void)didChangeStock;
@end

@interface StockAgent : NSObject 
<DDHttpClientDelegate> {

}

@property (nonatomic, retain) HttpClient *httpClient;
@property (nonatomic, assign) id<StockAgentDelegate> delegate;
@property (nonatomic, retain) NSArray *stockItemArray;
@property (nonatomic, retain)NSArray *stockSymbolArray;
@property (nonatomic, retain)NSMutableDictionary *stockNameDictionary;
+ (StockAgent *)sharedStockAgent;
+ (void)releaseSharedStockAgent;

- (void) requestStock;
- (StockItem *) stockItemForSymbol:(NSString *)simbol;
- (NSString *) nextStockSymbol:(NSString *)symbol;
@end


