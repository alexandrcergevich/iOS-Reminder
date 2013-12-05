//
//  WeatherItem.h
//  AlarmAndClock
//
//  Created by Alexandr on 11/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WeatherItem : NSObject {

}

@property (nonatomic, copy) NSString *unitTemperature;
@property (nonatomic, copy) NSString *unitDistance;
@property (nonatomic, copy) NSString *unitPressure;
@property (nonatomic, copy) NSString *unitSpeed;
@property (nonatomic, copy) NSString *windSpeed;
@property (nonatomic, copy) NSString *condition;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *temperature;
@end
