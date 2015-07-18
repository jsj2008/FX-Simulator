//
//  SimpleMovingAverageSource.h
//  FX Simulator
//
//  Created by yuu on 2015/07/13.
//
//

#import <Foundation/Foundation.h>
#import "IndicatorSource.h"

@import UIKit;

@interface SimpleMovingAverageSource : IndicatorSource
@property (nonatomic) NSUInteger term;
@property (nonatomic) UIColor *lineColor;
+ (NSString *)indicatorName;
@end
