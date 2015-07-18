//
//  IndicatorSourceFactory.m
//  FX Simulator
//
//  Created by yuu on 2015/07/13.
//
//

#import "IndicatorSourceFactory.h"

#import "IndicatorSource.h"
#import "SimpleMovingAverage.h"
#import "SimpleMovingAverageSource.h"

@implementation IndicatorSourceFactory

+ (IndicatorSource *)createFrom:(NSDictionary *)dic
{
    NSString *indicatorName = dic[[IndicatorSource indicatorNameKey]];
    
    if ([indicatorName isEqualToString:[SimpleMovingAverageSource indicatorName]]) {
        return [[SimpleMovingAverageSource alloc] initWithDictionary:dic];
    }
    
    return nil;
}

@end
