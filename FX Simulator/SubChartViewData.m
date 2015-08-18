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
#import "Chart.h"
#import "ChartChunk.h"
#import "Market.h"
#import "ForexHistoryData.h"
#import "Setting.h"
#import "TimeFrame.h"
#import "TimeFrameChunk.h"
#import "Rate.h"
#import "SimulationManager.h"
#import "MarketTime.h"

@implementation SubChartViewData {
    SaveData *saveData;
    Market *market;
    TimeFrameChunk *timeScaleList;
}

-(id)init
{
    if (self = [super init]) {
        saveData = [SaveLoader load];
        market = [SimulationManager sharedSimulationManager].market;
        timeScaleList = [[Setting timeFrameList] getTimeFrameChunkExecept:saveData.timeFrame];
        _selectedSegmentIndex = [self toSegmentIndexFromTimeScale:saveData.subChartChunk.selectedChart.timeFrame];
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
    return (TimeFrame*)[timeScaleList timeFrameAtIndex:index];
}

- (NSUInteger)toSegmentIndexFromTimeScale:(TimeFrame *)timeScale
{
    return [timeScaleList indexOfTimeFrame:timeScale];
}

-(NSArray*)items
{
    NSMutableArray *array = [NSMutableArray array];
    
    [timeScaleList enumerateTimeFrames:^(TimeFrame *timeFrame) {
        [array addObject:timeFrame.toDisplayString];
    }];
    
    return [array copy];
}

- (TimeFrame *)selectedTimeScale
{
    return [timeScaleList timeFrameAtIndex:self.selectedSegmentIndex];
}

@end
