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
#import "TimeFrame.h"
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
        timeScaleList = [TimeScaleUtils selectTimeScaleListExecept:saveData.timeFrame fromTimeScaleList:[Setting timeScaleList]];
        _selectedSegmentIndex = [self toSegmentIndexFromTimeScale:saveData.subChartSelectedTimeScale];
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

-(NSArray*)getChartDataArrayWithTimeScale:(TimeFrame*)timeScale
{
    ForexHistoryData *data = market.currentForexHistoryData;
    
    /*NSArray *array = [ForexTimeScaleDataArrayFactory createArrayFromMaxCloseTimestamp:data.close.timestamp.timestampValue limit:40 currencyPair:saveData.currencyPair timeScale:timeScale];*/
    
    return nil;
}

-(TimeFrame*)toTimeScalefFromSegmentIndex:(int)index
{
    return (TimeFrame*)[timeScaleList objectAtIndex:index];
}

- (NSUInteger)toSegmentIndexFromTimeScale:(TimeFrame *)timeScale
{
    return [timeScaleList indexOfObject:timeScale];
}

-(NSArray*)items
{
    NSMutableArray *array = [NSMutableArray array];
    
    //NSArray *timeScaleList = [TimeScaleUtils selectTimeScaleListExecept:saveData.timeScale fromTimeScaleList:[Setting timeScaleList]];
    
    for (TimeFrame *timeScale in timeScaleList) {
        [array addObject:timeScale.toDisplayString];
    }
    
    return [array copy];
}

- (TimeFrame *)selectedTimeScale
{
    return [timeScaleList objectAtIndex:self.selectedSegmentIndex];
}

@end
