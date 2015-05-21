//
//  CandlesUtils.m
//  FX Simulator
//
//  Created  on 2014/10/30.
//  
//

#import "ForexHistoryDataArrayUtils.h"
#import "ForexHistoryData.h"

@implementation ForexHistoryDataArrayUtils

+(double)maxRateOfArray:(NSArray*)array
{
    return [[array valueForKeyPath:@"@max.high.rateValue"] doubleValue];
}

+(double)minRateOfArray:(NSArray*)array
{
    return [[array valueForKeyPath:@"@min.low.rateValue"] doubleValue];
}

@end
