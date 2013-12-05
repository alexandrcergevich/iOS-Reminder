//
//  Global.h
//  eNews
//
//  Created by kgi on 8/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define OBJECT_SINGLETON_BOILERPLATE(_object_name_, _shared_obj_name_) \
static _object_name_ *z##_shared_obj_name_ = nil;  \
+ (_object_name_ *)_shared_obj_name_ {             \
@synchronized(self) {                            \
if (z##_shared_obj_name_ == nil) {             \
/* Note that 'self' may not be the same as _object_name_ */                               \
/* first assignment done in allocWithZone but we must reassign in case init fails */      \
z##_shared_obj_name_ = [[self alloc] init];                                               \
}                                              \
}                                                \
return z##_shared_obj_name_;                     \
}                                                  \
+ (id)allocWithZone:(NSZone *)zone {               \
@synchronized(self) {                            \
if (z##_shared_obj_name_ == nil) {             \
z##_shared_obj_name_ = [super allocWithZone:zone]; \
return z##_shared_obj_name_;                 \
}                                              \
}                                                \
\
/* We can't return the shared instance, because it's been init'd */ \
return nil;                                    \
}                                                  \
- (id)retain {                                     \
return self;                                   \
}                                                  \
- (NSUInteger)retainCount {                        \
return NSUIntegerMax;                          \
}                                                  \
- (void)release {                                  \
}                                                  \
- (id)autorelease {                                \
return self;                                   \
}                                                  \
- (id)copyWithZone:(NSZone *)zone {                \
return self;                                   \
}      

extern BOOL			isFirstLoad;

@interface Global : NSObject {

}

+ (natural_t) get_free_memory;
+ (void) alert_free_memory;

@end

@interface NSDictionary (Extend)
- (NSString *) safeStringForKey: (id)key;
@end