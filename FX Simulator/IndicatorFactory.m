//
//  IndicatorFactory.m
//  FX Simulator
//
//  Created by yuu on 2015/07/13.
//
//

#import "IndicatorFactory.h"

#import "SimpleMovingAverage.h"
#import "SimpleMovingAverageSource.h"

@implementation IndicatorFactory

+ (Indicator *)createFromSource:(IndicatorSource *)source
{
    if ([source isKindOfClass:[SimpleMovingAverageSource class]]) {
        return [[SimpleMovingAverage alloc] initWithSource:(SimpleMovingAverageSource *)source];
    }
    
    return nil;
}

@end
