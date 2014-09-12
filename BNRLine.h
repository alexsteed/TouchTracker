//
//  BNRLine.h
//  TouchTracker
//
//  Created by Alexis Bastide on 09/09/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNRLine : NSObject

- (void)setLineColor;

@property (nonatomic)CGPoint begin;
@property (nonatomic)CGPoint end;
@property (nonatomic)UIColor *color;

@end
