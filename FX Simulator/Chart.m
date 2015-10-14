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
#import "EntityChart.h"
#import "ForexDataChunk.h"
#import "ForexHistoryData.h"
#import "Market.h"
#import "IndicatorChunk.h"
#import "Rate.h"
#import "SaveDataSource.h"

// 偶数
static const NSUInteger FXSDefaultDisplayDataCount = 300;
static const NSUInteger FXSMinDisplayDataCount = 30;
static const NSUInteger FXSMaxDisplayDataCount = 200;
static const float FXSEntityChartViewPrepareTotalRangeRatio = 0.5;

@interface Chart ()
@property (nonatomic) float visibleWidthRatio;
@property (nonatomic) EntityChart *currentEntityChart;
@end

@implementation Chart {
    UIImageView *_entityChartView;
    __weak UIView *_visibleChartView;
    Market *_market;
    __block BOOL _inAnimation;
    float _startScaleX;
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
        _entityChartView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 2000, 1000)];
        _visibleWidthRatio = 0.25;
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

- (void)strokeCurrentChart:(Market *)market
{
    _market = market;
    
    _entityChartView.transform = CGAffineTransformIdentity;
    
    EntityChart *newCurrentEntityChart = [[EntityChart alloc] initWithCurrencyPair:self.currencyPair timeFrame:self.timeFrame indicatorChunk:self.indicatorChunk viewSize:_entityChartView.frame.size];
    [newCurrentEntityChart strokeForMarket:market];
    
    self.currentEntityChart = newCurrentEntityChart;
    
    float startX = _entityChartView.frame.size.width - (_entityChartView.frame.size.width * self.visibleWidthRatio);
    float endX = startX + (_entityChartView.frame.size.width * self.visibleWidthRatio);
    
    __block UIView *entityChartView = _entityChartView;
    [self setVisibleViewForStartX:startX endX:endX setNormalizedEntityChartFrameBlock:^(float x, float y, float width, float height) {
        entityChartView.frame = CGRectMake(x, y, width, height);
    }];

}

/**
 EntityChart(scale前)のstartXからendXまでを、表示するようにする。
*/
- (void)setVisibleViewForStartX:(float)startX endX:(float)endX setNormalizedEntityChartFrameBlock:(void (^)(float x, float y, float width, float height))setNormalizedEntityChartFrameBlock
{
    if (startX < 0 || !setNormalizedEntityChartFrameBlock) {
        return;
    }
    
    _entityChartView.transform = CGAffineTransformIdentity;
    
    ForexDataChunk *visibleForexDataChunk = [self.currentEntityChart chunkForRangeStartX:startX endX:endX];
    
    if (!visibleForexDataChunk) {
        return;
    }
    
    float scaleX = _visibleChartView.frame.size.width / (endX - startX);
    
    double differenceEntityChartMaxMinRate = self.currentEntityChart.maxRate.rateValue - self.currentEntityChart.minRate.rateValue;
    double visibleChartMaxRate = [visibleForexDataChunk getMaxRate].rateValue;
    double visibleChartMinRate = [visibleForexDataChunk getMinRate].rateValue;
    double differenceVisibleChartMaxMinRate = visibleChartMaxRate - visibleChartMinRate;
    // scale後のEntityChartの高さ。
    float scaledEntityChartViewHeight = _visibleChartView.frame.size.height / (differenceVisibleChartMaxMinRate / differenceEntityChartMaxMinRate);
    // 元のEntityChartからどれだけscaleするのか。
    float scaleY = scaledEntityChartViewHeight / _entityChartView.frame.size.height;
    
    _entityChartView.transform = CGAffineTransformMakeScale(scaleX, scaleY);
    
    float entityChartViewX = _visibleChartView.frame.origin.x - (startX * _entityChartView.transform.a);
    
    double entityChartMaxRate = self.currentEntityChart.maxRate.rateValue;
    // scale後のEntityChartでの1pipあたりの画面サイズ(Y)
    float onePipEntityChartViewDisplaySize = _entityChartView.frame.size.height / differenceEntityChartMaxMinRate;
    // 表示されているチャートの中で最大のレートが、EntityChartでどの位置(Y)にあるのか
    float visibleChartMaxRateYOfEntityChart = (entityChartMaxRate - visibleChartMaxRate) * onePipEntityChartViewDisplaySize;
    float entityChartViewY = _visibleChartView.frame.origin.y - visibleChartMaxRateYOfEntityChart;
    
    setNormalizedEntityChartFrameBlock(entityChartViewX, entityChartViewY, _entityChartView.frame.size.width, _entityChartView.frame.size.height);
}

- (void)scaleStart
{
    _startScaleX = _entityChartView.transform.a;
}

- (void)scaleEnd
{
    _startScaleX = 0;
}

- (void)scaleX:(float)scaleX
{
    if (_startScaleX <= 0) {
        return;
    }
    
    CALayer *entityChartViewLayer = _entityChartView.layer.presentationLayer;
    
    float startVisibleViewOfEntityChart = (_visibleChartView.frame.origin.x - entityChartViewLayer.frame.origin.x) / _entityChartView.transform.a;
    float endVisibleViewOfEntityChart = startVisibleViewOfEntityChart + (_visibleChartView.frame.size.width / _entityChartView.transform.a);
    // EntityChart(scale前)で現在表示されている範囲の中間(x)
    float centerLineX = (startVisibleViewOfEntityChart + endVisibleViewOfEntityChart) / 2;
    
    _entityChartView.transform = CGAffineTransformMakeScale(_startScaleX * scaleX, _entityChartView.transform.d);
    
    float newVisibleViewWidth = _visibleChartView.frame.size.width / _entityChartView.transform.a;
    
    float normalizedStartX = centerLineX - (newVisibleViewWidth / 2);
    float normalizedEndX = centerLineX + (newVisibleViewWidth / 2);
    
    __block UIView *entityChartView = _entityChartView;
    [self setVisibleViewForStartX:normalizedStartX endX:normalizedEndX setNormalizedEntityChartFrameBlock:^(float x, float y, float width, float height) {
        entityChartView.frame = CGRectMake(x, y, width, height);
    }];
    
    self.visibleWidthRatio = (normalizedEndX - normalizedStartX) / (_entityChartView.frame.size.width / _entityChartView.transform.a);
    
    [self didChangeEntityChartViewPositionX];
}

- (void)translate:(float)tx
{
    if (fabs(tx) == 0) {
        return;
    }
    
    float newEntityChartViewX = _entityChartView.frame.origin.x + tx;
    float newEntityChartViewEndX = newEntityChartViewX + _entityChartView.frame.size.width;
    
    float visibleChartViewX = _visibleChartView.frame.origin.x;
    float visibleChartViewEndX = visibleChartViewX + _visibleChartView.frame.size.width;
    
    if (visibleChartViewX < newEntityChartViewX) {
        if (!self.currentEntityChart.previousEntityChart && 0 < tx) {
            return;
        }
    } else if (newEntityChartViewEndX < visibleChartViewEndX) {
        if (!self.currentEntityChart.nextEntityChart && tx < 0) {
            return;
        }
    }
    
    CGPoint movedPoint = CGPointMake(_entityChartView.center.x + tx, _entityChartView.center.y);
    _entityChartView.center = movedPoint;
    
    [self didChangeEntityChartViewPositionX];
    
    [self normalizeEntityChartView];
}

- (void)animateTranslation:(float)tx duration:(float)duration
{
    if (!_inAnimation) {
        
        NSOperationQueue *queue = [NSOperationQueue new];
        
        [queue addOperationWithBlock:^{
            while (_inAnimation) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    CALayer *layer = _entityChartView.layer.presentationLayer;
                    if (0 < layer.frame.origin.x) {
                        float tx = _entityChartView.frame.origin.x - layer.frame.origin.x;
                        [self didChangeEntityChartViewPositionX];
                        _entityChartView.frame = CGRectMake(_entityChartView.frame.origin.x + tx, _entityChartView.frame.origin.y, _entityChartView.frame.size.width, _entityChartView.frame.size.height);
                    } else {
                        [self didChangeEntityChartViewPositionX];
                    }
                }];
                [NSThread sleepForTimeInterval:0.1];
            }
        }];
        
        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^ {
            _inAnimation = YES;
            _entityChartView.center = CGPointMake(_entityChartView.center.x+1000, _entityChartView.center.y);
        } completion:^(BOOL finished) {
            _inAnimation = NO;
        }];
    }
}

- (void)removeAnimation
{
    [_entityChartView.layer removeAllAnimations];
    _inAnimation = NO;
}

- (void)prepareChart
{
    if ([self isInPreparePreviousChartRange]) {
        [_currentEntityChart preparePreviousEntityChartForMarket:_market];
    }
    
    if ([self isInPrepareNextChartRange]) {
        [_currentEntityChart prepareNextEntityChartForMarket:_market];
    }
}

- (void)checkEntityChartViewOverVisibleChartView
{
    float visibleViewStartX;
    float visibleViewEndX;
    
    if ([self isOverEntityChartViewLeftEnd]) {
    
        EntityChart *newCurrentEntityChart = _currentEntityChart.previousEntityChart;
        
        if (!newCurrentEntityChart) {
            return;
        }
        
        self.currentEntityChart = newCurrentEntityChart;
        
        _entityChartView.transform = CGAffineTransformIdentity;
        
        visibleViewStartX = self.currentEntityChart.visibleViewDefaultStartX;
        
        if (visibleViewStartX < 0) {
            return;
        }
        
        visibleViewEndX = visibleViewStartX + (_entityChartView.frame.size.width * self.visibleWidthRatio);
        
    } else if ([self isOverEntityChartViewRightEnd]) {
        
        EntityChart *newCurrentEntityChart = _currentEntityChart.nextEntityChart;
        
        if (!newCurrentEntityChart) {
            if ([self isOverEntityChartViewMoveRangeRightEnd]) {
                [self setEntityChartViewMoveRangeRightEnd];
            }
            return;
        }
        
        self.currentEntityChart = newCurrentEntityChart;
        
        _entityChartView.transform = CGAffineTransformIdentity;
        
        visibleViewEndX = self.currentEntityChart.visibleViewDefaultEndX;
        
        if (visibleViewEndX < 0) {
            return;
        }
        
        visibleViewStartX = visibleViewEndX - (_entityChartView.frame.size.width * self.visibleWidthRatio);
        
    } else {
        return;
    }
    
    __block UIView *entityChartView = _entityChartView;
    [self setVisibleViewForStartX:visibleViewStartX endX:visibleViewEndX setNormalizedEntityChartFrameBlock:^(float x, float y, float width, float height) {
        entityChartView.frame = CGRectMake(x, y, width, height);
    }];
}

- (void)didChangeEntityChartViewPositionX
{
    [self prepareChart];
    [self checkEntityChartViewOverVisibleChartView];
}

- (void)normalizeEntityChartView
{
    CALayer *entityChartViewLayer = _entityChartView.layer.presentationLayer;
    
    float startVisibleViewOfEntityChart = (_visibleChartView.frame.origin.x - entityChartViewLayer.frame.origin.x) / _entityChartView.transform.a;
    float endVisibleViewOfEntityChart = startVisibleViewOfEntityChart + (_visibleChartView.frame.size.width / _entityChartView.transform.a);
    
    float entityChartViewX = _entityChartView.frame.origin.x;
    __block UIView *entityChartView = _entityChartView;
    [self setVisibleViewForStartX:startVisibleViewOfEntityChart endX:endVisibleViewOfEntityChart setNormalizedEntityChartFrameBlock:^(float x, float y, float width, float height) {
        entityChartView.frame = CGRectMake(entityChartViewX, y, width, height);
    }];
}

- (void)setCurrentEntityChart:(EntityChart *)currentEntityChart
{
    _currentEntityChart = currentEntityChart;
    _entityChartView.image = _currentEntityChart.image;
}

- (BOOL)isOverEntityChartViewLeftEnd
{
    CALayer *entityChartViewLayer = _entityChartView.layer.presentationLayer;
    
    if (0 < entityChartViewLayer.frame.origin.x) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isOverEntityChartViewRightEnd
{
    CALayer *entityChartViewLayer = _entityChartView.layer.presentationLayer;
    
    if ((entityChartViewLayer.frame.origin.x + entityChartViewLayer.frame.size.width) < (_visibleChartView.frame.origin.x + _visibleChartView.frame.size.width)) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isOverEntityChartViewMoveRangeLeftEnd
{
    float entityChartViewX = _entityChartView.frame.origin.x;
    
    if ([self entityChartViewMoveRangeLeftEndX] < entityChartViewX) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isOverEntityChartViewMoveRangeRightEnd
{
    float entityChartViewEndX = _entityChartView.frame.origin.x + _entityChartView.frame.size.width;
    
    if (entityChartViewEndX < [self entityChartViewMoveRangeRightEndX]) {
        return YES;
    } else {
        return NO;
    }
}

- (void)setEntityChartViewMoveRangeLeftEnd
{
    float newEntityChartViewX = [self entityChartViewMoveRangeLeftEndX];
    
    _entityChartView.frame = CGRectMake(newEntityChartViewX, _entityChartView.frame.origin.y, _entityChartView.frame.size.width, _entityChartView.frame.size.height);
}


- (void)setEntityChartViewMoveRangeRightEnd
{
    float newEntityChartViewX = [self entityChartViewMoveRangeRightEndX] - _entityChartView.frame.size.width;
    
    _entityChartView.frame = CGRectMake(newEntityChartViewX, _entityChartView.frame.origin.y, _entityChartView.frame.size.width, _entityChartView.frame.size.height);
}

- (float)entityChartViewMoveRangeRightEndX
{
    float visibleChartViewEndX = _visibleChartView.frame.origin.x + _visibleChartView.frame.size.width;
    
    return visibleChartViewEndX - [self maxMarginOfVisibleChartViewAndEntityChartView];
}

- (float)entityChartViewMoveRangeLeftEndX
{
    return _visibleChartView.frame.origin.x + [self maxMarginOfVisibleChartViewAndEntityChartView];
}

- (float)maxMarginOfVisibleChartViewAndEntityChartView
{
    return _visibleChartView.frame.size.width / 4;
}

- (BOOL)isInPreparePreviousChartRange
{
    if (_visibleChartView.frame.origin.x <= [self entityChartViewPreparePreviousChartRangeStartX]) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isInPrepareNextChartRange
{
    float visibleChartViewEndX = _visibleChartView.frame.origin.x + _visibleChartView.frame.size.width;
    
    if ([self entityChartViewPrepareNextChartRangeStartX] <= visibleChartViewEndX) {
        return YES;
    } else {
        return NO;
    }
}

- (float)entityChartViewPreparePreviousChartRangeStartX
{
    CALayer *entityChartViewLayer = _entityChartView.layer.presentationLayer;
    
    return entityChartViewLayer.frame.origin.x + [self entityChartViewPrepareRangeWidth];
}

- (float)entityChartViewPrepareNextChartRangeStartX
{
    CALayer *entityChartViewLayer = _entityChartView.layer.presentationLayer;
    
    float entityChartViewRightEndX = entityChartViewLayer.frame.origin.x + entityChartViewLayer.frame.size.width;
    
    return entityChartViewRightEndX - [self entityChartViewPrepareRangeWidth];
}

- (float)entityChartViewPrepareRangeWidth
{
    return _entityChartView.frame.size.width * FXSEntityChartViewPrepareTotalRangeRatio / 2;
}

- (void)setVisibleChartView:(UIView *)visibleView
{
    _visibleChartView = visibleView;
    [_visibleChartView addSubview:_entityChartView];
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
