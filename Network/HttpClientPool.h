//
//  HttpClientPool.h
//  eNews
//
//  Created by kgi on 8/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum HttpClientPoolClientType {
	
	GeneralClient,
	ImageClient,
	
} HttpClientPoolClientType;

@interface HttpClientPool : NSObject {
	NSMutableArray *clientsActive;
	NSMutableArray *clientsIdle;
}

+ (HttpClientPool*)sharedInstance;

- (id)idleClientWithType:(HttpClientPoolClientType)type;
- (void)releaseClient:(id)client;
- (void)removeAllIdleObjects;
- (int)activeClientCountWithType:(HttpClientPoolClientType)type;

- (void)addIdleClientObserver:(id)observer selector:(SEL)selector;
- (void)removeIdleClientObserver:(id)observer;

@end
