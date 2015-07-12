//
//  SubChartViewData.m
//  FX Simulator
//
//  Created  on 2014/11/19.
//  
//

#import "SubChartViewData.h"

#import "SaveLoader.h"
#import "SaveData.h"
#import "Market.h"
#import "ForexHistoryData.h"
#import "Setting.h"
#import "TimeScaleUtils.h"
#import "MarketTimeScale.h"
#import "Rate.h"
#import "SimulationManager.h"
#import "MarketTime.h"

@implementation SubChartViewData {
    SaveData *saveData;
    Market *market;
    NSArray *timeScaleList;
}

-(id)init
{
    if (self = [super init]) {
        saveData = [SaveLoader load];
        market = [SimulationManager sharedSimulationManager].market;
        timeScaleList = [TimeScaleUtils selectTimeScaleListExecept:saveData.timeScale fromTimeScaleList:[Setting timeScaleList]];
    }
    
    return self;
}

- (ForexDataChunk *)getCurrentChunk
{
    return market.currentForexDataChunk;
}

-(NSArray*)getChartDataArray
{
    ForexHistoryData *data = market.currentForexHistoryData;
    
    /*NSArray *array = [ForexTimeScaleDataArrayFactory createArrayFromMaxCloseTimestamp:data.close.timestamp.timestampValue limit:40 currencyPair:saveData.currencyPair timeScale:saveData.subChartSelectedTimeScale];
    
    return array;*/
    
    return nil;
}

-(NSArray*)getChartDataArrayWithTimeScale:(MarketTimeScale*)timeScale
{
    ForexHistoryData *data = market.currentForexHistoryData;
    
    /*NSArray *array = [ForexTimeScaleDataArrayFactory createArrayFromMaxCloseTimestamp:data.close.timestamp.timestampValue limit:40 currencyPair:saveData.currencyPair timeScale:timeScale];*/
    
    return nil;
}

-(MarketTimeScale*)toTimeScalefFromSegmentIndex:(int)index
{
    return (MarketTimeScale*)[timeScaleList objectAtIndex:index];
}

-(NSArray*)items
{
    NSMutableArray *array = [NSMutableArray array];
    
    //NSArray *timeScaleList = [TimeScaleUtils selectTimeScaleListExecept:saveData.timeScale fromTimeScaleList:[Setting timeScaleList]];
    
    for (MarketTimeScale *timeScale in timeScaleList) {
        [array addObject:timeScale.toDisplayString];
    }
    
    return [array copy];
}

@end
