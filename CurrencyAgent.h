//
//  CurrencyAgent.h
//  AlarmAndClock
//
//  Created by Alexandr on 11/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpClient.h"
#import "XMLReaderCurrency.h"
#import "CurrencyItem.h"

@protocol CurrencyAgentDelegate

- (void)didChangeCurrency:(CurrencyItem *)currencyItem;
@end

@interface CurrencyAgent : NSObject <DDHttpClientDelegate>{

}
@property (nonatomic, retain) HttpClient *httpClient;

@property (nonatomic, assign) id<CurrencyAgentDelegate> delegate;
@property (nonatomic, retain)NSArray *currencyNameArray;
@property (nonatomic, retain)CurrencyItem *loadedCurrencyItem;
+ (CurrencyAgent *)sharedCurrencyAgent;
+ (void)releaseSharedCurrencyAgent;

- (void) requestCurrency;
@end
