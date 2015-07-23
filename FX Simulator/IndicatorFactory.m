//
//  IndicatorFactory.m
//  FX Simulator
//
//  Created by yuu on 2015/07/13.
//
//

#import "IndicatorFactory.h"

#import "SimpleMovingAverage.h"
#import "SimpleMovingAveragePlistSource.h"

@implementation IndicatorFactory

+ (Indicator *)createFromSource:(IndicatorPlistSource *)source
{
    if ([source isKindOfClass:[SimpleMovingAveragePlistSource class]]) {
        return [[SimpleMovingAverage alloc] initWithSource:(SimpleMovingAveragePlistSource *)source];
    }
    
    return nil;
}

@end
