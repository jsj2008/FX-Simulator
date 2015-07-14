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

+ (id<Indicator>)createFromSource:(id<IndicatorSource>)source
{
    if ([source isKindOfClass:[SimpleMovingAverage class]]) {
        return [[SimpleMovingAverage alloc] initWithIndicatorSource:source];
    }
    
    return nil;
}

@end
