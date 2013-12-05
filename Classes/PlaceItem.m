//
//  PlaceInfo.m
//  AlarmAndClock
//
//  Created by Alexandr on 11/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PlaceItem.h"

@implementation PlaceItem;
@synthesize woeID, placeName, countryName, countryCode;
@synthesize addr1, addr2, postal, latitudeCenter, longitudeCenter;

- (void)dealloc {
	[woeID release];
	[placeName release];
	[countryName release];
	[countryCode release];
	[addr1 release];
	[addr2 release];
	[postal release];
	[latitudeCenter release];
	[longitudeCenter release];
	[self dealloc];
}
@end
