//
//  Chart.m
//  FX Simulator
//
//  Created by yuu on 2015/07/18.
//
//

#import "Chart.h"

#import "CoreDataManager.h"
#import "Coordinate.h"
#import "ChartSource.h"
#import "Candle.h"
#import "EntityChart.h"
#import "ForexDataChunk.h"
#import "ForexHistoryData.h"
#import "Market.h"
#import "IndicatorChunk.h"
#import "Rate.h"
#import "SaveDataSource.h"
#import "VisibleChartArea.h"

@interface Chart ()
@property (nonatomic) EntityChart *currentEntityChart;
@end

@implementation Chart {
    UIImageView *_entityChartView;
    VisibleChartArea *_visibleChartArea;
    Market *_market;
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
    chart.chartSource.saveDataSourceForMain = source;
    
    return chart;
}

+ (instancetype)createNewSubChartFromSaveDataSource:(SaveDataSource *)source
{
    Chart *chart = [self createNewChart];
    
    [source addSubChartSourcesObject:chart.chartSource];
    chart.chartSource.saveDataSourceForSub = source;
    
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
        _entityChartView = [EntityChart entityChartView];
    }
    
    return self;
}

- (void)chartScrollViewDidLoad
{
    [_visibleChartArea chartScrollViewDidLoad];
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

- (void)strokeCurrentChart:(Market *)market
{
    _market = market;
    
    EntityChart *newCurrentEntityChart = [[EntityChart alloc] initWithCurrencyPair:self.currencyPair timeFrame:self.timeFrame indicatorChunk:self.indicatorChunk];
    [newCurrentEntityChart strokeForMarket:market];
    
    self.currentEntityChart = newCurrentEntityChart;
    
    [_visibleChartArea visibleForRightEndOfEntityChart];
}

- (void)chartScrollViewDidScroll
{
    [_visibleChartArea chartScrollViewDidScroll];
    
    [self didChangeEntityChartViewPositionX];
}

- (ForexHistoryData *)forexDataOfVisibleChartViewPoint:(CGPoint)point
{
    return [_visibleChartArea forexDataOfVisibleChartViewPoint:point];
}

- (void)scaleStart
{
    [_visibleChartArea scaleStart];
}

- (void)scaleEnd
{
    [_visibleChartArea scaleEnd];
}

- (void)scaleX:(float)scaleX
{
    [_visibleChartArea scaleX:scaleX];
    
    self.displayDataCount = _visibleChartArea.displayDataCount;
    
    [self didChangeEntityChartViewPositionX];
}

- (void)prepareChart
{
    if ([_visibleChartArea isInPreparePreviousChartRange]) {
        [_currentEntityChart preparePreviousEntityChartForMarket:_market];
    }
    
    if ([_visibleChartArea isInPrepareNextChartRange]) {
        [_currentEntityChart prepareNextEntityChartForMarket:_market];
    }
}

- (void)updateEntityChartView
{
    if ([_visibleChartArea isOverLeftEnd]) {
        
        EntityChart *newCurrentEntityChart = self.currentEntityChart.previousEntityChart;
        
        if (!newCurrentEntityChart) {
            return;
        }
        
        self.currentEntityChart = newCurrentEntityChart;
        
        Coordinate *visibleViewStartXObj = self.currentEntityChart.visibleViewDefaultStartX;
        
        if (!visibleViewStartXObj) {
            return;
        }
        
        float visibleViewStartX = visibleViewStartXObj.value;
        
        [_visibleChartArea visibleForStartXOfEntityChart:visibleViewStartX];
        
    } else if ([_visibleChartArea isOverRightEnd]) {
        
        EntityChart *newCurrentEntityChart = self.currentEntityChart.nextEntityChart;
        
        if (!newCurrentEntityChart) {
            return;
        }
        
        self.currentEntityChart = newCurrentEntityChart;
        
        Coordinate *visibleViewEndXObj = self.currentEntityChart.visibleViewDefaultEndX;
        
        if (!visibleViewEndXObj) {
            return;
        }
        
        float visibleViewEndX = visibleViewEndXObj.value;
        
        [_visibleChartArea visibleForEndXOfEntityChart:visibleViewEndX];
    }

}

- (void)didChangeEntityChartViewPositionX
{
    [self prepareChart];
    [self updateEntityChartView];
}

- (void)setCurrentEntityChart:(EntityChart *)currentEntityChart
{
    _currentEntityChart = currentEntityChart;
    _visibleChartArea.currentEntityChart = _currentEntityChart;
}

- (void)setChartScrollView:(UIScrollView *)chartScrollView
{
    for (UIView *view in chartScrollView.subviews) {
        [view removeFromSuperview];
    }
    
    [chartScrollView addSubview:_entityChartView];
    
    _visibleChartArea = [[VisibleChartArea alloc] initWithVisibleChartView:chartScrollView entityChartView:_entityChartView displayDataCount:self.displayDataCount];
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
    return _chartSource.displayDataCount;
}

- (void)setDisplayDataCount:(NSUInteger)displayDataCount
{
    _chartSource.displayDataCount = (int)displayDataCount;
}

@end
