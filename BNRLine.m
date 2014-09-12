//
//  BNRLine.m
//  TouchTracker
//
//  Created by Alexis Bastide on 09/09/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

#import "BNRLine.h"

@implementation BNRLine

- (CGFloat)getLineAngle
{
    CGFloat abLen = sqrt(pow((self.end.x - self.begin.x), 2) +
                         pow((self.end.y - self.begin.y), 2));
    CGFloat angle = 0;
    if (abLen != 0)
    {
        angle = acosf((self.end.x - self.begin.x) / abLen);
        if (self.end.y > self.begin.y)
            angle = (2 * M_PI - angle);
    }
    return angle;
}

- (void)setLineColor
{
    CGFloat angle = [self getLineAngle];
    CGFloat red = angle / (2 * M_PI);
    CGFloat green = fabsf(1 - angle / M_PI);
    CGFloat blue = 1 - angle / (2 * M_PI);
    _color = [UIColor colorWithRed:red green:green blue:blue alpha:1];
}

@end
