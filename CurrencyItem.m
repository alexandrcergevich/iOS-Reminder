//
//  CurrencyItem.m
//  AlarmAndClock
//
//  Created by Alexandr on 11/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CurrencyItem.h"


@implementation CurrencyItem
@synthesize eur, usd, jpy, gbp, cad, hkd, cny, aud;

- (id)init {
	if ((self = [super init]))
	{
		eur = 1.0;
		usd = 1.0;
		jpy = 1.0;
		gbp = 1.0;
		cad = 1.0;
		hkd = 1.0;
		cny = 1.0;
		aud = 1.0;
	}
	return self;
}
@end
