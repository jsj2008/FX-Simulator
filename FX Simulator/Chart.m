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
#import "Candle.h"
#import "ForexDataChunk.h"
#import "IndicatorChunk.h"
#import "SaveDataSource.h"

@implementation Chart {
    ForexDataChunk *_displayedForexDataChunk;
    NSUInteger _displayedForexDataCount;
    CGSize _displayedViewSize;
}

+ (instancetype)createNewChart
{
    NSManagedObjectContext *context = [CoreDataManager sharedManager].managedObjectContext;
    
    Chart *chart = [[Chart alloc] initWithChartSource:[NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([ChartSource class]) inManagedObjectContext:context]];
    
    return chart;
}

+ (instancetype)createNewMainChartFromSaveDataSource:(SaveDataSource *)source
{
    Chart *chart = [self createNewChart];
    
    [source addMainChartSourcesObject:chart.chartSource];
    
    return chart;
}

+ (instancetype)createNewSubChartFromSaveDataSource:(SaveDataSource *)source
{
    Chart *chart = [self createNewChart];
    
    [source addSubChartSourcesObject:chart.chartSource];
    
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

- (void)strokeFromForexDataChunk:(ForexDataChunk *)chunk viewSize:(CGSize)size
{
    _displayedForexDataChunk = chunk;
    _displayedViewSize = size;
    
    if (![self.indicatorChunk existsBaseIndicator]) {
        Candle *candle = [Candle createTemporaryDefaultCandle];
        [candle strokeIndicatorFromForexDataChunk:_displayedForexDataChunk displayDataCount:self.displayDataCount displaySize:_displayedViewSize];
    } else {
        [self.indicatorChunk strokeIndicatorFromForexDataChunk:_displayedForexDataChunk displayDataCount:self.displayDataCount displaySize:_displayedViewSize];
    }
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

- (NSUInteger)displayDataCount
{
    return 50;
}

@end
