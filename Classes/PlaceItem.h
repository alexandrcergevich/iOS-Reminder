//
//  PlaceInfo.h
//  AlarmAndClock
//
//  Created by Alexandr on 11/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PlaceItem : NSObject {

}

@property (nonatomic, copy) NSString *woeID;
@property (nonatomic, copy) NSString *placeName;
@property (nonatomic, copy) NSString *countryName;
@property (nonatomic, copy) NSString *countryCode;
@property (nonatomic, copy) NSString *addr1;
@property (nonatomic, copy) NSString *addr2;
@property (nonatomic, copy) NSString *postal;
@property (nonatomic, copy) NSString *latitudeCenter;
@property (nonatomic, copy) NSString *longitudeCenter;

@end
