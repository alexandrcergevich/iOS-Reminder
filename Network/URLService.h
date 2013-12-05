//
//  URLService.h
//  eNews
//
//  Created by kgi on 8/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface URLService : NSObject {

}

+ (URLService *) instance;
+ (void) deinit;

+ (NSString*) reqPlaceUrlByQuery:(NSString *)query;
+ (NSString *) reqPlaceForLocationUrlByQuery:(NSString *)query;
+ (NSString*) reqWeatherUrlByWoeID:(NSString *)woeID andUnit:(NSString *)unit;
+ (NSString*) reqStockUrl;
+ (NSString*) reqCurrencyUrl;
@end

URLService * Url();
