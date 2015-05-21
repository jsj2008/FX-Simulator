//
//  ForexHistoryUtils.m
//  FX Simulator
//
//  Created  on 2014/11/12.
//  
//

#import "ForexHistoryUtils.h"

@implementation ForexHistoryUtils

+(NSString*)createTableName:(NSString*)currencyPair timeScale:(int)minute
{
    return [NSString stringWithFormat:@"%@_%d_minute", currencyPair, minute];
}

@end
