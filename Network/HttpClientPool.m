//
//  HttpClientPool.m
//  eNews
//
//  Created by kgi on 8/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HttpClientPool.h"
#import "HttpClient.h"
#import "Global.h"

#define IDLE_CLIENT_NOTIFICATION		@"IDLE_CLIENT_NOTIFICATION"

@implementation HttpClientPool

OBJECT_SINGLETON_BOILERPLATE(HttpClientPool, sharedInstance)

- (id)init {
	if (self = [super init]) {
		clientsActive = [[NSMutableArray alloc] init];
		clientsIdle = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)dealloc {
	[clientsActive release];
	[clientsIdle release];
	[super dealloc];
}

- (Class)classFromType:(HttpClientPoolClientType)type {
	switch (type) {
		case GeneralClient:
			return [HttpClient class];
		case ImageClient:
			break;
	}
	return [NSNull class];
}

- (id)idleClientWithType:(HttpClientPoolClientType)type {
	
	id ret = nil;
	@synchronized (self) {
		Class klass = [self classFromType:type];
		for (id a in clientsIdle) {
			if ([a isMemberOfClass:klass]) {
				[clientsActive addObject:a];
				[clientsIdle removeObject:a];
				ret = a;
				break;
			}
		}
		
		if (ret == nil) {
			ret = [[klass alloc] init];
			[clientsActive addObject:ret];
			[ret release];
		}
	}
	
	if (clientsActive.count == 1) {
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	}
	return ret;
}

- (void)hideNetworkActivityIndicator {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)releaseClient:(id)client {
	@synchronized (self) {
		[clientsActive addObject:client];
		[clientsActive removeObject:client];
		
		if (clientsActive.count == 0) {
			[NSObject cancelPreviousPerformRequestsWithTarget:self 
													 selector:@selector(hideNetworkActivityIndicator) 
													   object:nil];
			[self performSelector:@selector(hideNetworkActivityIndicator) 
					   withObject:nil 
					   afterDelay:0.3];
		}
		
		NSNotification *notification = [NSNotification notificationWithName:IDLE_CLIENT_NOTIFICATION
																	 object:self];
		[[NSNotificationCenter defaultCenter] postNotification:notification];
	}
}

- (void)removeAllIdleObjects {
	[clientsIdle removeAllObjects];
}

- (int)activeClientCountWithType:(HttpClientPoolClientType)type {
	int cnt = 0;
	@synchronized (self) {
		Class klass = [self classFromType:type];
		for (id a in clientsActive) {
			if ([a isKindOfClass:klass]) {
				cnt++;
			}
		}
	}
	return cnt;
}

- (void)addIdleClientObserver:(id)observer selector:(SEL)selector {
	[[NSNotificationCenter defaultCenter] addObserver:observer 
											 selector:selector 
												 name:IDLE_CLIENT_NOTIFICATION 
											   object:nil];
}

- (void)removeIdleClientObserver:(id)observer {
	[[NSNotificationCenter defaultCenter] removeObserver:observer];
}

@end
