//
//  SimpleMovingAverageSource.h
//  FX Simulator
//
//  Created by yuu on 2015/07/13.
//
//

#import <Foundation/Foundation.h>
#import "IndicatorPlistSource.h"

@import UIKit;

@interface SimpleMovingAveragePlistSource : IndicatorPlistSource
@property (nonatomic) NSUInteger term;
@property (nonatomic) UIColor *lineColor;
+ (NSString *)indicatorName;
@end
