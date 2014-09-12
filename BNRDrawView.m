//
//  BNRDrawView.m
//  TouchTracker
//
//  Created by Alexis Bastide on 09/09/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

#import "BNRDrawView.h"
#import "BNRLine.h"

@interface BNRDrawView ()

@property (nonatomic, strong) NSValue *beginKey;
@property (nonatomic, strong) NSValue *endKey;
@property (nonatomic, strong) BNRLine *lineInProgess;
@property (nonatomic, strong) NSMutableArray *finishedLines;

@end

@implementation BNRDrawView

#pragma mark - initalization

- (instancetype)initWithFrame:(CGRect)r
{
    self = [super initWithFrame:r];
    
    if (self)
    {
        self.beginKey = nil;
        self.endKey = nil;
        self.lineInProgess = nil;
        self.finishedLines = [[NSMutableArray alloc] init];
        self.backgroundColor = [UIColor grayColor];
        self.multipleTouchEnabled = YES;
    }
    return self;
}

#pragma mark - drawing management

- (CGFloat)distanceBetween:(CGPoint)firstPoint and:(CGPoint)secondPoint
{
    CGFloat distance = sqrtf(powf((secondPoint.x - firstPoint.x), 2) + powf((secondPoint.y - firstPoint.y), 2));
    return distance;
}

- (void)strokeCircle:(BNRLine *)line
{
    CGPoint center;
    float radius;
    UIBezierPath *path = [UIBezierPath bezierPath];

    path.lineWidth = 10;
    path.lineCapStyle = kCGLineCapRound;
    center.x = (line.end.x + line.begin.x) / 2.0;
    center.y = (line.end.y + line.begin.y) / 2.0;
    radius = [self distanceBetween:line.begin and:line.end] / 2.0;
    [path moveToPoint:CGPointMake(center.x + radius, center.y)];
    [path addArcWithCenter:center radius:radius startAngle:0 endAngle:M_PI * 2.0 clockwise:YES];
    [path stroke];
}

- (void)drawRect:(CGRect)rect
{
    for (BNRLine *line in self.finishedLines)
    {
        [line.color set];
        [self strokeCircle:line];
    }
    if (self.endKey != nil && self.beginKey != nil)
    {
        BNRLine *line = self.lineInProgess;
        [line setLineColor];
        [line.color set];
        [self strokeCircle:line];
    }
}

#pragma mark - touch event management

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Let's put in a log statement to see the order of events
    NSLog(@"%@", NSStringFromSelector(_cmd));
    for (UITouch *t in touches)
    {
        CGPoint location = [t locationInView:self];
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        if (self.beginKey == nil)
        {
            self.beginKey = key;
            self.lineInProgess = [[BNRLine alloc] init];
            self.lineInProgess.begin = location;
        }
        else if (self.beginKey != nil && self.endKey == nil)
        {
            self.endKey = key;
            self.lineInProgess.end = location;
        }
    }
    if ([[touches allObjects] count] > 1)
        [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Let's put in a log statement to see the order of events
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    for (UITouch *t in touches)
    {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        BNRLine *line = self.lineInProgess;
        if ([key isEqual:self.beginKey])
            line.begin = [t locationInView:self];
        else if ([key isEqual:self.endKey])
            line.end = [t locationInView:self];
    }
    if ([[touches allObjects] count] > 1)
        [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Let's put in a log statement to see the order of events
    NSLog(@"%@", NSStringFromSelector(_cmd));
    for (UITouch *t in touches)
    {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        BNRLine *line = self.lineInProgess;
        if ([key isEqual:self.beginKey])
        {
            if (self.endKey != nil)
                [self.finishedLines addObject:line];
            self.beginKey = nil;
            self.endKey = nil;
            self.lineInProgess = nil;
        }
        else if ([key isEqual:self.endKey])
        {
            [self.finishedLines addObject:line];
            self.beginKey = nil;
            self.endKey = nil;
            self.lineInProgess = nil;
        }
    }
    [self setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Let's put in a log statement to see the order of events
    NSLog(@"%@",NSStringFromSelector(_cmd));
    self.lineInProgess = nil;
    self.beginKey = nil;
    self.endKey = nil;
    [self setNeedsDisplay];
}

@end
