//
//  Chart.m
//  FX Simulator
//
//  Created by yuu on 2015/07/18.
//
//

#import "Chart.h"

#import "CoreDataManager.h"
#import "ChartView.h"
#import "ChartSource.h"
#import "Candle.h"
#import "ForexDataChunk.h"
#import "IndicatorChunk.h"
#import "SaveDataSource.h"

static const NSUInteger FXSDefaultDisplayDataCount = 40;
static const NSUInteger FXSMinDisplayDataCount = 30;
static const NSUInteger FXSMaxDisplayDataCount = 80;

@implementation Chart {
    __weak ChartView *_chartView;
    ForexDataChunk *_forexDataChunk;
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

- (void)stroke
{
    if (_chartView == nil) {
        return;
    }
    
    CGSize viewSize = _chartView.frame.size;
    
    if (![self.indicatorChunk existsBaseIndicator]) {
        Candle *candle = [Candle createTemporaryDefaultCandle];
        [candle strokeIndicatorFromForexDataChunk:_forexDataChunk displayDataCount:self.displayDataCount displaySize:viewSize];
    } else {
        [self.indicatorChunk strokeIndicatorFromForexDataChunk:_forexDataChunk displayDataCount:self.displayDataCount displaySize:viewSize];
    }
    
    _displayedForexDataChunk = _forexDataChunk;
    _displayedViewSize = viewSize;
}

- (BOOL)isEqualChartIndex:(NSUInteger)index
{
    if (_chartSource.chartIndex == index) {
        return YES;
    }
    
    return NO;
}

- (void)setChartView:(ChartView *)chartView
{
    _chartView = chartView;
}

- (void)setForexDataChunk:(ForexDataChunk *)chunk
{
    _forexDataChunk = chunk;
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

- (BOOL)isDisplay
{
    return _chartSource.isDisplay;
}

- (void)setIsDisplay:(BOOL)isDisplay
{
    _chartSource.isDisplay = isDisplay;
}

- (NSUInteger)displayDataCount
{
    if (_chartSource.displayDataCount == 0) {
        return FXSDefaultDisplayDataCount;
    } else if (_chartSource.displayDataCount < FXSMinDisplayDataCount) {
        return FXSMinDisplayDataCount;
    } else if (FXSMaxDisplayDataCount < _chartSource.displayDataCount) {
        return FXSMaxDisplayDataCount;
    }
    
    return _chartSource.displayDataCount;
}

- (void)setDisplayDataCount:(NSUInteger)displayDataCount
{
    _chartSource.displayDataCount = displayDataCount;
}

@end
