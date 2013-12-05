//
//  UITappingScrollView.m
//  AlarmAndClock
//
//  Created by Alexandr on 11/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "UITappingScrollView.h"

@implementation UITappingScrollView
@synthesize touchDelegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.touchDelegate = nil;
    }
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.dragging)
    {
        if (self.touchDelegate)
            [touchDelegate didTouch];
    }
    else
        [super touchesEnded:touches withEvent:event];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
