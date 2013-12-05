//
//  MaskView.m
//  AlarmAndClock
//
//  Created by Alexandr on 11/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MaskView.h"


@implementation MaskView


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
	return NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
}
- (void)dealloc {
    [super dealloc];
}


@end
