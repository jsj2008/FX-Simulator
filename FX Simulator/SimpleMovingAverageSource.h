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
- (instancetype)initWithDictionary:(NSDictionary *)dic;
@property (nonatomic) NSUInteger term;
@property (nonatomic) UIColor *lineColor;
@end
