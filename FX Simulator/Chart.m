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

// 偶数
static const NSUInteger FXSDefaultDisplayDataCount = 60;
static const NSUInteger FXSMinDisplayDataCount = 60;
static const NSUInteger FXSMaxDisplayDataCount = 100;

@interface Chart ()
@property (nonatomic) float visibleWidthRatio;
@property (nonatomic) EntityChart *currentEntityChart;
@end

@implementation Chart {
    UIImageView *_entityChartView;
    VisibleChartArea *_visibleChartArea;
    __weak UIView *_visibleChartView;
    Market *_market;
    __block BOOL _inAnimation;
    BOOL _inScale;
    float _scaleX;
    float _previousScaleX;
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
        _visibleWidthRatio = (float)self.displayDataCount / (float)[EntityChart forexDataCount];
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
    [self endAnimation];
    
    _market = market;
    
    EntityChart *newCurrentEntityChart = [[EntityChart alloc] initWithCurrencyPair:self.currencyPair timeFrame:self.timeFrame indicatorChunk:self.indicatorChunk];
    [newCurrentEntityChart strokeForMarket:market];
    
    self.currentEntityChart = newCurrentEntityChart;
    
    float startX = _entityChartView.frame.size.width - (_entityChartView.frame.size.width * self.visibleWidthRatio);
    float endX = startX + (_entityChartView.frame.size.width * self.visibleWidthRatio);
    
    [_visibleChartArea visibleForStartXOfEntityChart:startX endXOfEntityChart:endX inAnimation:NO];
}

- (ForexHistoryData *)forexDataOfVisibleChartViewPoint:(CGPoint)point
{
    [self endAnimation];
    
    float entityChartViewX = (point.x - _entityChartView.frame.origin.x) / _entityChartView.transform.a;
    float entityChartViewY = (point.y - _entityChartView.frame.origin.y) / _entityChartView.transform.d;
    
    return [self.currentEntityChart forexDataOfEntityChartPoint:CGPointMake(entityChartViewX, entityChartViewY)];
}

- (void)scaleStart
{
    [self endAnimation];
    
    _inScale = YES;
    _scaleX = _entityChartView.transform.a;
    _previousScaleX = 1;
}

- (void)scaleEnd
{
    _inScale = NO;
}

- (void)scaleX:(float)scaleX
{
    if (!_inScale) {
        return;
    }
    
    if (![self canScaleForCurrentScale:scaleX previousScale:_previousScaleX]) {
        _previousScaleX = scaleX;
        return;
    }
    
    _scaleX = _scaleX * (1 - (_previousScaleX - scaleX));
    
    _previousScaleX = scaleX;
    
    float newVisibleViewWidth = _visibleChartView.frame.size.width / _scaleX;
    
    float startVisibleViewOfEntityChart = (_visibleChartView.frame.origin.x - _entityChartView.frame.origin.x) / _entityChartView.transform.a;
    float endVisibleViewOfEntityChart = startVisibleViewOfEntityChart + (_visibleChartView.frame.size.width / _entityChartView.transform.a);
    // EntityChart(scale前)で現在表示されている範囲の中間(x)
    float centerLineXOfEntityChart = (startVisibleViewOfEntityChart + endVisibleViewOfEntityChart) / 2;
    
    float normalizedStartX = centerLineXOfEntityChart - (newVisibleViewWidth / 2);
    float normalizedEndX = centerLineXOfEntityChart + (newVisibleViewWidth / 2);
    
    [_visibleChartArea visibleForStartXOfEntityChart:normalizedStartX endXOfEntityChart:normalizedEndX inAnimation:NO];
    
    self.visibleWidthRatio = (normalizedEndX - normalizedStartX) / (_entityChartView.frame.size.width / _entityChartView.transform.a);
    
    [self didChangeEntityChartViewPositionX];
}

- (BOOL)canScaleForCurrentScale:(float)currentScale previousScale:(float)previousScale
{
    if (currentScale < previousScale) {
        return [self canScaleDown];
    } else if (previousScale < currentScale) {
        return [self canScaleUp];
    } else {
        return NO;
    }
}

- (BOOL)canScaleDown
{
    if (FXSMaxDisplayDataCount <= self.displayDataCount) {
        return NO;
    }
    
    return YES;
}

- (BOOL)canScaleUp
{
    if (self.displayDataCount <= FXSMinDisplayDataCount) {
        return NO;
    }
    
    return YES;
}

- (void)translate:(float)tx
{
    [self endAnimation];
    
    if (fabs(tx) == 0) {
        return;
    }
    
    if (![self canTranslate:tx]) {
        return;
    }
    
    float newEntityChartViewX = _entityChartView.frame.origin.x + tx;
    float newEntityChartViewEndX = newEntityChartViewX + _entityChartView.frame.size.width;
    
    float visibleChartViewX = _visibleChartView.frame.origin.x;
    float visibleChartViewEndX = visibleChartViewX + _visibleChartView.frame.size.width;
    
    if (![_visibleChartArea isOverLeftEnd] && visibleChartViewX < newEntityChartViewX) {
        if (!self.currentEntityChart.previousEntityChart) {
            tx = visibleChartViewX - _entityChartView.frame.origin.x;
        }
    } else if (![_visibleChartArea isOverRightEnd] && newEntityChartViewEndX < visibleChartViewEndX) {
        if (!self.currentEntityChart.nextEntityChart) {
            tx = visibleChartViewEndX - (_entityChartView.frame.origin.x + _entityChartView.frame.size.width);
        }
    }
    
    CGPoint movedPoint = CGPointMake(_entityChartView.center.x + tx, _entityChartView.center.y);
    _entityChartView.center = movedPoint;
    
    [self didChangeEntityChartViewPositionX];
    
    [self normalizeEntityChartView];
}

- (BOOL)canTranslate:(float)tx
{
    if ([_visibleChartArea isOverRightEnd] && tx < 0) {
        if (!self.currentEntityChart.nextEntityChart) {
            return NO;
        }
    }
    
    if ([_visibleChartArea isOverLeftEnd] && 0 < tx) {
        if (!self.currentEntityChart.previousEntityChart) {
            return NO;
        }
    }
    
    return YES;
}

- (void)animateTranslation:(float)tx duration:(float)duration
{
    [self endAnimation];
    
    if ([_visibleChartArea isOverLeftEnd] && 0 < tx) {
        if (!self.currentEntityChart.previousEntityChart) {
            return;
        }
    } else if ([_visibleChartArea isOverRightEnd] && tx < 0) {
        if (!self.currentEntityChart.nextEntityChart) {
            return;
        }
    }
    
    if (!_inAnimation) {
        
        NSOperationQueue *queue = [NSOperationQueue new];
        
        [queue addOperationWithBlock:^{
            while (_inAnimation) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [self didAnimate];
                }];
                [NSThread sleepForTimeInterval:0.05];
            }
        }];
        
        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^ {
            _inAnimation = YES;
            _entityChartView.center = CGPointMake(_entityChartView.center.x + tx, _entityChartView.center.y);
        } completion:^(BOOL finished) {
            _inAnimation = NO;
        }];
    }
}

- (void)endAnimation
{
    [_entityChartView.layer removeAllAnimations];
    _inAnimation = NO;
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

- (BOOL)updateEntityChartView
{
    float visibleViewStartX;
    float visibleViewEndX;
    
    float animateTx = 0;
    
    if (_inAnimation) {
        CALayer *layer = _entityChartView.layer.presentationLayer;
        animateTx = _entityChartView.frame.origin.x - layer.frame.origin.x;
    }
    
    if ([_visibleChartArea isOverLeftEnd]) {
        
        EntityChart *newCurrentEntityChart = self.currentEntityChart.previousEntityChart;
        
        if (!newCurrentEntityChart) {
            return NO;
        }
        
        self.currentEntityChart = newCurrentEntityChart;
        
        Coordinate *visibleViewStartXObj = self.currentEntityChart.visibleViewDefaultStartX;
        
        if (!visibleViewStartXObj) {
            return NO;
        }
        
        visibleViewStartX = visibleViewStartXObj.value;
        
        visibleViewEndX = visibleViewStartX + (_entityChartView.frame.size.width * self.visibleWidthRatio);
        
    } else if ([_visibleChartArea isOverRightEnd]) {
        
        EntityChart *newCurrentEntityChart = self.currentEntityChart.nextEntityChart;
        
        if (!newCurrentEntityChart) {
            return NO;
        }
        
        self.currentEntityChart = newCurrentEntityChart;
        
        Coordinate *visibleViewEndXObj = self.currentEntityChart.visibleViewDefaultEndX;
        
        if (!visibleViewEndXObj) {
            return NO;
        }
        
        visibleViewEndX = visibleViewEndXObj.value;
        
        visibleViewStartX = visibleViewEndX - (_entityChartView.frame.size.width * self.visibleWidthRatio);
        
    } else {
        return NO;
    }
    
    [_visibleChartArea visibleForStartXOfEntityChart:visibleViewStartX endXOfEntityChart:visibleViewEndX inAnimation:NO];
    
    if (_inAnimation) {
        _entityChartView.frame = CGRectMake(_entityChartView.frame.origin.x + animateTx, _entityChartView.frame.origin.y, _entityChartView.frame.size.width, _entityChartView.frame.size.height);
    }
    
    return YES;
}

- (void)didAnimate
{
    if (!_inAnimation) {
        return;
    }
    
    [self prepareChart];
    
    CALayer *entityChartViewLayer = _entityChartView.layer.presentationLayer;
    float animationTx = _entityChartView.frame.origin.x - entityChartViewLayer.frame.origin.x;
    
    if ([_visibleChartArea isOverLeftEnd] && 0 < animationTx) {
        if (!self.currentEntityChart.previousEntityChart) {
            [self endAnimation];
            [_visibleChartArea setLeftEnd];
        }
    } else if ([_visibleChartArea isOverRightEnd] && animationTx < 0) {
        if (!self.currentEntityChart.nextEntityChart) {
            [self endAnimation];
            [_visibleChartArea setRightEnd];
        }
    }
    
    if (![self updateEntityChartView]) {
        [self normalizeEntityChartViewInAnimation];
    }
}

- (void)didChangeEntityChartViewPositionX
{
    [self prepareChart];
    [self updateEntityChartView];
}

- (void)normalizeEntityChartView
{
    float startVisibleViewOfEntityChart = (_visibleChartView.frame.origin.x - _entityChartView.frame.origin.x) / _entityChartView.transform.a;
    float endVisibleViewOfEntityChart = startVisibleViewOfEntityChart + (_visibleChartView.frame.size.width / _entityChartView.transform.a);
    
    [_visibleChartArea visibleForStartXOfEntityChart:startVisibleViewOfEntityChart endXOfEntityChart:endVisibleViewOfEntityChart inAnimation:NO];
}

- (void)normalizeEntityChartViewInAnimation
{
    CALayer *entityChartViewLayer = _entityChartView.layer.presentationLayer;
    
    float startVisibleViewOfEntityChart = (_visibleChartView.frame.origin.x - entityChartViewLayer.frame.origin.x) / _entityChartView.transform.a;
    float endVisibleViewOfEntityChart = startVisibleViewOfEntityChart + (_visibleChartView.frame.size.width / _entityChartView.transform.a);
    
    [_visibleChartArea visibleForStartXOfEntityChart:startVisibleViewOfEntityChart endXOfEntityChart:endVisibleViewOfEntityChart inAnimation:YES];
}

- (void)setCurrentEntityChart:(EntityChart *)currentEntityChart
{
    _currentEntityChart = currentEntityChart;
    _entityChartView.transform = CGAffineTransformIdentity;
    _entityChartView.image = _currentEntityChart.chartImage;
    _visibleChartArea.currentEntityChart = _currentEntityChart;
}

- (void)setVisibleChartView:(UIView *)visibleView
{
    _visibleChartView = visibleView;
    
    for (UIView *view in _visibleChartView.subviews) {
        [view removeFromSuperview];
    }
    
    [_visibleChartView addSubview:_entityChartView];
    
    _visibleChartArea = [[VisibleChartArea alloc] initWithVisibleChartView:_visibleChartView entityChartView:_entityChartView];
}

- (void)setVisibleWidthRatio:(float)visibleWidthRatio
{
    _visibleWidthRatio = visibleWidthRatio;
    
    self.displayDataCount = [EntityChart forexDataCount] * _visibleWidthRatio;
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
