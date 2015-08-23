//
//  Chart.m
//  FX Simulator
//
//  Created by yuu on 2015/07/18.
//
//

#import "Chart.h"

#import "CoreDataManager.h"
#import "ChartSource.h"
#import "ForexDataChunk.h"
#import "SaveDataSource.h"

@implementation Chart {
    ForexDataChunk *_currentForexDataChunk;
}

+ (instancetype)createNewChartFromSaveDataSource:(SaveDataSource *)source
{
    NSManagedObjectContext *context = [CoreDataManager sharedManager].managedObjectContext;
    
    Chart *chart = [[Chart alloc] initWithChartSource:[NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([ChartSource class]) inManagedObjectContext:context]];
    
    [source addMainChartSourcesObject:chart.chartSource];
    
    return chart;
}

+ (instancetype)createChartFromChartSource:(ChartSource *)source
{
    return [[self alloc] initWithChartSource:source];
}

- (instancetype)initWithChartSource:(ChartSource *)source
{
    if (self = [super init]) {
        _chartSource = source;
    }
    
    return self;
}

- (NSComparisonResult)compareDisplayOrder:(Chart *)chart
{
    if (self.chartIndex < chart.chartIndex) {
        return NSOrderedAscending;
    } else if (self.chartIndex > chart.chartIndex) {
        return NSOrderedDescending;
    } else {
        return NSOrderedSame;
    }
}

- (void)setForexDataChunk:(ForexDataChunk *)chunk
{
    _currentForexDataChunk = chunk;
}

- (void)stroke
{
    
}

- (BOOL)isEqualChartIndex:(NSUInteger)index
{
    if (_chartSource.chartIndex == index) {
        return YES;
    }
    
    return NO;
}

#pragma mark - getter,setter

- (NSUInteger)chartIndex
{
    return _chartSource.chartIndex;
}

- (void)setChartIndex:(NSUInteger)chartIndex
{
    _chartSource.chartIndex = (int)chartIndex;
}

- (CurrencyPair *)currencyPair
{
    return _chartSource.currencyPair;
}

- (void)setCurrencyPair:(CurrencyPair *)currencyPair
{
    _chartSource.currencyPair = currencyPair;
}

- (TimeFrame *)timeFrame
{
    return _chartSource.timeFrame;
}

- (void)setTimeFrame:(TimeFrame *)timeFrame
{
    _chartSource.timeFrame = timeFrame;
}

- (BOOL)isSelected
{
    return _chartSource.isSelected;
}

- (void)setIsSelected:(BOOL)isSelected
{
    _chartSource.isSelected = isSelected;
}


@end
