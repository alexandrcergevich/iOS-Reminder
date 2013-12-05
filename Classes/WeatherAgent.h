//
//  WeatherAgent.h
//  AlarmAndClock
//
//  Created by Alexandr on 11/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpClient.h"
#import "XMLReaderWeather.h"
#import "WeatherItem.h"
@protocol WeatherAgentDelegate

- (void)didChangeWeather:(WeatherItem *)weatherItem;
@end


@interface WeatherAgent : NSObject
<DDHttpClientDelegate> 
{
}

@property (nonatomic, retain) HttpClient *httpClient;
@property (nonatomic, retain)WeatherItem *weatherItem; 
@property (nonatomic, assign) id<WeatherAgentDelegate> delegate;
+ (WeatherAgent *)sharedWeatherAgent;
+ (void)releaseSharedWeatherAgent;

- (void) requestWeatherWithWoeID:(NSString *)woeID andUnit:(int)unit;
@end
