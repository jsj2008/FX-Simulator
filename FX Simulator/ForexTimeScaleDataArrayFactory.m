//
//  ForexTimeScaleDataArrayFactory.m
//  FX Simulator
//
//  Created  on 2014/11/14.
//  
//

#import "ForexTimeScaleDataArrayFactory.h"

#import "MarketTimeScale.h"
#import "ForexHistoryFactory.h"
#import "ForexHistory.h"
#import "ForexHistoryData.h"
#import "Rate.h"
#import "MarketTime.h"

static int minTimeScaleMinute = 15;

@implementation ForexTimeScaleDataArrayFactory

+(NSArray*)createArrayFromMaxCloseTimestamp:(int)closeTimestamp limit:(int)num currencyPair:(CurrencyPair*)currencyPair timeScale:(MarketTimeScale*)timeScale
{
    ForexHistory *forexHistory = [ForexHistoryFactory createForexHistoryFromCurrencyPair:currencyPair timeScale:timeScale];
    
    NSArray *_forexTimeScaleDataArray = [forexHistory selectMaxCloseTimestamp:closeTimestamp limit:num];
    
    NSMutableArray *array = [_forexTimeScaleDataArray mutableCopy];
    
    ForexHistoryData *lastData = [array lastObject];
    
    if (closeTimestamp > lastData.close.timestamp.timestampValue) {
        MarketTimeScale *minTimeScale = [[MarketTimeScale alloc] initWithMinute:minTimeScaleMinute];
        ForexHistory *minTimeScaleForexHistory = [ForexHistoryFactory createForexHistoryFromCurrencyPair:currencyPair timeScale:minTimeScale];
        NSArray *_array = [minTimeScaleForexHistory selectMaxCloseTimestamp:closeTimestamp minOpenTimestamp:lastData.close.timestamp.timestampValue + 1];
        ForexHistoryData *newLastData = [[ForexHistoryData alloc] initWithForexHistoryDataArray:_array];
        
        [array removeObjectAtIndex:0];
        [array addObject:newLastData];
    }
    
    return [array copy];
}
@end
