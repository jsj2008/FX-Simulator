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
#import "ForexHistoryData.h"
#import "Market.h"
#import "IndicatorChunk.h"
#import "Rate.h"
#import "SaveDataSource.h"

// 偶数
static const NSUInteger FXSDefaultDisplayDataCount = 200;
static const NSUInteger FXSMinDisplayDataCount = 30;
static const NSUInteger FXSMaxDisplayDataCount = 200;

@interface Chart ()
@property (nonatomic) float visibleWidthRatio;
@end

@implementation Chart {
    UIImageView *_entityChartView;
    __weak UIView *_visibleChartView;
    ForexDataChunk *_forexDataChunk;
    ForexDataChunk *_forexDataChunkOfEntityChart;
    double _forexDataChunkOfEntityChartMaxRate;
    double _forexDataChunkOfEntityChartMinRate;
    Market *_market;
    Candle *_candle;
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
        //_entityChartView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1000, 1000)];
        //_visibleWidthRatio = 0.5;
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
    
    _forexDataChunk = [_market chunkForCurrencyPair:self.currencyPair timeFrame:self.timeFrame Limit:500];
    
    [self strokeEntityChart];
    
    float startX = _entityChartView.frame.size.width - (_entityChartView.frame.size.width * self.visibleWidthRatio);
    float endX = startX + (_entityChartView.frame.size.width * self.visibleWidthRatio);
    
    __block UIView *entityChartView = _entityChartView;
    [self setVisibleViewForStartX:startX endX:endX setNormalizedEntityChartFrameBlock:^(float x, float y, float width, float height) {
        entityChartView.frame = CGRectMake(x, y, width, height);
    }];
    //[self setVisibleViewForStartX:_entityChartView.frame.size.width - (_entityChartView.frame.size.width * self.visibleWidthRatio)];
}

- (void)strokeEntityChart
{
    //@autoreleasepool {
    
    _forexDataChunkOfEntityChart = [_forexDataChunk chunkLimit:self.displayDataCount];
    _forexDataChunkOfEntityChartMaxRate = [_forexDataChunkOfEntityChart getMaxRate].rateValue;
    _forexDataChunkOfEntityChartMinRate = [_forexDataChunkOfEntityChart getMinRate].rateValue;
    
    _entityChartView.transform = CGAffineTransformIdentity;
    
    UIGraphicsBeginImageContextWithOptions(_entityChartView.frame.size, NO, 0.0);
    
    CGSize viewSize = _entityChartView.frame.size;
    
    if (![self.indicatorChunk existsBaseIndicator]) {
        _candle = [Candle createTemporaryDefaultCandle];
        [_candle strokeIndicatorFromForexDataChunk:_forexDataChunk displayDataCount:self.displayDataCount displaySize:viewSize];
    }
    
    [self.indicatorChunk strokeIndicatorFromForexDataChunk:_forexDataChunk displayDataCount:self.displayDataCount displaySize:viewSize];
    
    _entityChartView.image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
        
    //}
}

/**
 EntityChartのstartXからendXまでを、表示するようにする。
*/
- (void)setVisibleViewForStartX:(float)startX endX:(float)endX setNormalizedEntityChartFrameBlock:(void (^)(float x, float y, float width, float height))setNormalizedEntityChartFrameBlock
{
    if (startX < 0 || !setNormalizedEntityChartFrameBlock) {
        return;
    }
    
    _entityChartView.transform = CGAffineTransformIdentity;
    
    ForexDataChunk *visibleForexDataChunk = [_candle chunkRangeStartX:startX endX:endX];
    
    if (!visibleForexDataChunk) {
        return;
    }
    
    float scaleX = _visibleChartView.frame.size.width / (endX - startX);
    
    double differenceEntityChartMaxMinRate = _forexDataChunkOfEntityChartMaxRate - _forexDataChunkOfEntityChartMinRate;
    double visibleChartMaxRate = [visibleForexDataChunk getMaxRate].rateValue;
    double visibleChartMinRate = [visibleForexDataChunk getMinRate].rateValue;
    double differenceVisibleChartMaxMinRate = visibleChartMaxRate - visibleChartMinRate;
    // scale後のEntityChartの高さ。
    float scaledEntityChartViewHeight = _visibleChartView.frame.size.height / (differenceVisibleChartMaxMinRate / differenceEntityChartMaxMinRate);
    // 元のEntityChartからどれだけscaleするのか。
    float scaleY = scaledEntityChartViewHeight / _entityChartView.frame.size.height;
    
    _entityChartView.transform = CGAffineTransformMakeScale(scaleX, scaleY);
    
    float entityChartViewX = _visibleChartView.frame.origin.x - (startX * _entityChartView.transform.a);
    
    double entityChartMaxRate = _forexDataChunkOfEntityChartMaxRate;
    // scale後のEntityChartでの1pipあたりの画面サイズ(Y)
    float onePipEntityChartViewDisplaySize = _entityChartView.frame.size.height / differenceEntityChartMaxMinRate;
    // 表示されているチャートの中で最大のレートが、EntityChartでどの位置(Y)にあるのか
    float visibleChartMaxRateYOfEntityChart = (entityChartMaxRate - visibleChartMaxRate) * onePipEntityChartViewDisplaySize;
    //float visibleChartMaxRateYOfEntityChart = _chartView.frame.size.height - (_chartView.frame.size.height * (visibleChartMaxRate / entityChartMaxRate));
    float entityChartViewY = _visibleChartView.frame.origin.y - visibleChartMaxRateYOfEntityChart;
    
    setNormalizedEntityChartFrameBlock(entityChartViewX, entityChartViewY, _entityChartView.frame.size.width, _entityChartView.frame.size.height);
    //_entityChartView.frame = CGRectMake(entityChartViewX, entityChartViewY, _entityChartView.frame.size.width, _entityChartView.frame.size.height);
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
    
    _entityChartView.transform = CGAffineTransformMakeScale(_startScaleX * scaleX, 1);
    
    float newVisibleViewWidth = _visibleChartView.frame.size.width / _entityChartView.transform.a;
    
    float normalizedStartX = centerLineX - (newVisibleViewWidth / 2);
    float normalizedEndX = centerLineX + (newVisibleViewWidth / 2);
    
    __block UIView *entityChartView = _entityChartView;
    [self setVisibleViewForStartX:normalizedStartX endX:normalizedEndX setNormalizedEntityChartFrameBlock:^(float x, float y, float width, float height) {
        entityChartView.frame = CGRectMake(x, y, width, height);
    }];
    
    self.visibleWidthRatio = (normalizedEndX - normalizedStartX) / (_entityChartView.frame.size.width / _entityChartView.transform.a);
    //self.visibleWidthRatio = _visibleChartView.frame.size.width / (endVisibleViewOfEntityChart - startVisibleViewOfEntityChart);
}

- (void)translate:(float)tx
{
    if (fabs(tx) == 0) {
        return;
    }
    
    CGPoint movedPoint = CGPointMake(_entityChartView.center.x + tx, _entityChartView.center.y);
    _entityChartView.center = movedPoint;
    [self didChangeEntityChartViewPositionX];
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

- (void)didChangeEntityChartViewPositionX
{
    CALayer *entityChartViewLayer = _entityChartView.layer.presentationLayer;
    
    if (0 < entityChartViewLayer.frame.origin.x) {
        ForexHistoryData *leftEndForexData = [_candle leftEndForexData];
        NSUInteger limit = self.displayDataCount / 2;
        ForexDataChunk *newForexDataChunkOfEntityChart = [_market chunkForCurrencyPair:self.currencyPair timeFrame:self.timeFrame centerForexData:leftEndForexData frontLimit:limit - 1 backLimit:limit];
        _forexDataChunk = newForexDataChunkOfEntityChart;
        [self strokeEntityChart];
        float visibleViewStartX = [_candle zoneStartXOfForexData:leftEndForexData];
        float visibleViewEndX = visibleViewStartX + (_entityChartView.frame.size.width * self.visibleWidthRatio);
        //float visibleViewEndX = visibleViewStartX + (_visibleChartView.frame.size.width * self.visibleWidthRatio);
        __block UIView *entityChartView = _entityChartView;
        [self setVisibleViewForStartX:visibleViewStartX endX:visibleViewEndX setNormalizedEntityChartFrameBlock:^(float x, float y, float width, float height) {
            entityChartView.frame = CGRectMake(x, y, width, height);
        }];
        return;
    }
    
    float startVisibleViewOfEntityChart = (_visibleChartView.frame.origin.x - entityChartViewLayer.frame.origin.x) / _entityChartView.transform.a;
    float endVisibleViewOfEntityChart = startVisibleViewOfEntityChart + (_visibleChartView.frame.size.width / _entityChartView.transform.a);

    float entityChartViewX = _entityChartView.frame.origin.x;
    __block UIView *entityChartView = _entityChartView;
    [self setVisibleViewForStartX:startVisibleViewOfEntityChart endX:endVisibleViewOfEntityChart setNormalizedEntityChartFrameBlock:^(float x, float y, float width, float height) {
        entityChartView.frame = CGRectMake(entityChartViewX, y, width, height);
    }];
    //_entityChartView.frame = CGRectMake(x, _entityChartView.frame.origin.y, _entityChartView.frame.size.width, _entityChartView.frame.size.height);
    /*float endVisibleViewOfEntityChart = startVisibleViewOfEntityChart + (_visibleChartView.frame.size.width / _entityChartView.transform.a);
    
    //float tx = _entityChartView.transform.tx;
    _entityChartView.transform = CGAffineTransformIdentity;
    //_entityChartView.transform = CGAffineTransformMakeTranslation(tx, 0);
    
    ForexDataChunk *visibleForexDataChunkOfEntityChart = [_forexDataChunk chunkLimit:self.displayDataCount];
    ForexDataChunk *visibleForexDataChunkOfVisibleChart = [_candle chunkRangeStartX:startVisibleViewOfEntityChart endX:endVisibleViewOfEntityChart];
    
    if (!visibleForexDataChunkOfVisibleChart) {
        return;
    }
    
    float scaleX = _visibleChartView.frame.size.width / (_entityChartView.frame.size.width * self.visibleWidthRatio);
    
    double differenceEntityChartMaxMinRate = [visibleForexDataChunkOfEntityChart getMaxRate].rateValue - [visibleForexDataChunkOfEntityChart getMinRate].rateValue;
    double differenceVisibleChartMaxMinRate = [visibleForexDataChunkOfVisibleChart getMaxRate].rateValue - [visibleForexDataChunkOfVisibleChart getMinRate].rateValue;
    float scaledEntityChartViewHeight = _visibleChartView.frame.size.height / (differenceVisibleChartMaxMinRate / differenceEntityChartMaxMinRate);
    float scaleY = scaledEntityChartViewHeight / _entityChartView.frame.size.height;
    
    _entityChartView.transform = CGAffineTransformMakeScale(scaleX, scaleY);
    
    double entityChartMaxRate = [visibleForexDataChunkOfEntityChart getMaxRate].rateValue;
    double visibleChartMaxRate = [visibleForexDataChunkOfVisibleChart getMaxRate].rateValue;
    float onePipEntityChartViewDisplaySize = _entityChartView.frame.size.height / differenceEntityChartMaxMinRate;
    float visibleChartMaxRateYOfEntityChart = (entityChartMaxRate - visibleChartMaxRate) * onePipEntityChartViewDisplaySize;
    float entityChartViewY = _visibleChartView.frame.origin.y - visibleChartMaxRateYOfEntityChart;
    
    //_entityChartView.frame = CGRectMake(entityChartViewLayer.frame.origin.x, entityChartViewY, _entityChartView.frame.size.width, _entityChartView.frame.size.height);
    _entityChartView.frame = CGRectMake(_entityChartView.frame.origin.x, entityChartViewY, _entityChartView.frame.size.width, _entityChartView.frame.size.height);*/
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
