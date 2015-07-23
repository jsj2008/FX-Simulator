//
//  IndicatorSourceFactory.m
//  FX Simulator
//
//  Created by yuu on 2015/07/13.
//
//

#import "IndicatorSourceFactory.h"

#import "IndicatorPlistSource.h"
#import "SimpleMovingAverage.h"
#import "SimpleMovingAveragePlistSource.h"

@implementation IndicatorSourceFactory

+ (IndicatorPlistSource *)createFrom:(NSDictionary *)dic
{
    NSString *indicatorName = dic[[IndicatorPlistSource indicatorNameKey]];
    
    if ([indicatorName isEqualToString:[SimpleMovingAveragePlistSource indicatorName]]) {
        return [[SimpleMovingAveragePlistSource alloc] initWithDictionary:dic];
    }
    
    return nil;
}

@end
