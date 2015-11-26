//
//  EntityChart.m
//  FXSimulator
//
//  Created by yuu on 2015/10/08.
//
//

#import "EntityChart.h"

#import "Candle.h"
#import "CoordinateRange.h"
#import "ForexHistoryData.h"
#import "ForexDataChunk.h"
#import "IndicatorChunk.h"
#import "Market.h"
#import "Time.h"

static CGSize FXSEntityChartViewSize;
static CGSize FXSEntityChartImageSize;
static CGSize FXSMiniEntityChartImageSize;
static const NSUInteger FXSEntityChartForexDataCount = 500;
static const NSUInteger FXSMiniEntityChartForexDataCount = 150;
static const NSUInteger FXSMaxIndicatorPeriod = 200;
static const NSUInteger FXSRequireForexDataCount = FXSEntityChartForexDataCount + FXSMaxIndicatorPeriod - 1;
static const NSUInteger FXSFrontLimitForPrepare = FXSEntityChartForexDataCount / 2 - 1;
static const NSUInteger FXSMinFrontLimit = 1;
static const NSUInteger FXSBackLimitForPrepare = FXSRequireForexDataCount - FXSMinFrontLimit - 1;

@interface EntityChart ()
@property (nonatomic) UIImage *chartImage;
@property (nonatomic) EntityChart *previousEntityChart;
@property (nonatomic) EntityChart *nextEntityChart;
@property (nonatomic) ForexHistoryData *visibleViewDefaultStartForexData;
@property (nonatomic) ForexHistoryData *visibleViewDefaultEndForexData;
@property (nonatomic, readonly) CGSize imageSize;
@end

@implementation EntityChart {
    CurrencyPair *_currencyPair;
    TimeFrame *_timeFrame;
    ForexDataChunk *_forexDataChunk;
    ForexDataChunk *_forexDataChunkOfEntityChart;
    NSUInteger _entityChartForexDataCount;
    Candle *_candle;
    IndicatorChunk *_indicatorChunk;
    NSObject *_syncPreviousEntityChart;
    NSObject *_syncNextEntityChart;
    BOOL _isStartedPreparePreviousEntityChart;
    BOOL _isStartedPrepareNextEntityChart;
    BOOL _isMiniChart;
}

@synthesize maxRate = _maxRate;
@synthesize minRate = _minRate;

+ (void)initialize
{
    FXSEntityChartViewSize = CGSizeMake(3000, 1000);
    FXSEntityChartImageSize = FXSEntityChartViewSize;
    FXSMiniEntityChartImageSize = CGSizeMake(1000, 1000);
}

+ (UIImageView *)entityChartView
{
    return [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, FXSEntityChartViewSize.width, FXSEntityChartViewSize.height)];
}

+ (NSUInteger)forexDataCount
{
    return FXSEntityChartForexDataCount;
}

- (instancetype)initWithCurrencyPair:(CurrencyPair *)currencyPair timeFrame:(TimeFrame *)timeFrame indicatorChunk:(IndicatorChunk *)indicatorChunk
{
    if (self = [super init]) {
        _currencyPair = currencyPair;
        _timeFrame = timeFrame;
        _indicatorChunk = indicatorChunk;
        
        _syncPreviousEntityChart = [NSObject new];
        _syncNextEntityChart = [NSObject new];
        
        _isMiniChart = NO;
    }
    
    return self;
}

- (void)strokeForMarket:(Market *)market
{
    ForexDataChunk *forexDataChunk = [market chunkForCurrencyPair:_currencyPair timeFrame:_timeFrame Limit:FXSRequireForexDataCount];
    _isMiniChart = YES;
    [self strokeForForexDataChunk:forexDataChunk];
}

- (void)strokeForForexDataChunk:(ForexDataChunk *)forexDataChunk
{
    _forexDataChunk = forexDataChunk;
    
    _forexDataChunkOfEntityChart = [_forexDataChunk chunkLimit:self.displayDataCount];
    
    [self setEntityChartImage];
}

- (void)setEntityChartImage
{
    @autoreleasepool {
    
    UIGraphicsBeginImageContextWithOptions(self.imageSize, NO, 0.0);
    
    if (![_indicatorChunk existsBaseIndicator]) {
        _candle = [Candle createTemporaryDefaultCandle];
        [_candle strokeIndicatorFromForexDataChunk:_forexDataChunk displayDataCount:self.displayDataCount imageSize:self.imageSize displaySize:FXSEntityChartViewSize];
    }
    
    [_indicatorChunk strokeIndicatorFromForexDataChunk:_forexDataChunk displayDataCount:self.displayDataCount imageSize:self.imageSize displaySize:FXSEntityChartViewSize];
    
    self.chartImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
        
    }
}

- (ForexDataChunk *)chunkForRangeStartX:(float)startX endX:(float)endX
{
    return [_candle chunkRangeStartX:startX endX:endX];
}

- (ForexHistoryData *)forexDataOfEntityChartPoint:(CGPoint)point
{
    return [_candle forexDataOfPoint:point];
}

- (ForexHistoryData *)leftEndForexData
{
    return [_candle leftEndForexData];
}

- (ForexHistoryData *)forexDataFromLeftEnd:(NSUInteger)index
{
    return [_candle forexDataFromLeftEnd:index];
}

- (void)preparePreviousEntityChartForMarket:(Market *)market
{
    if (_isStartedPreparePreviousEntityChart) {
        return;
    }
            
    _isStartedPreparePreviousEntityChart = YES;
    
    NSOperationQueue *queue = [NSOperationQueue new];
    
    [queue addOperationWithBlock:^{
        @synchronized (_syncPreviousEntityChart) {
            ForexHistoryData *leftEndForexData = [_candle leftEndForexData];
            ForexDataChunk *newForexDataChunk = [market chunkForCenterForexData:leftEndForexData frontLimit:FXSFrontLimitForPrepare backLimit:FXSBackLimitForPrepare];
            
            NSComparisonResult result = [leftEndForexData.oldestTime compareTime:newForexDataChunk.oldestTime];
            
            if (result != NSOrderedDescending) {
                return;
            }
            
            self.previousEntityChart = [[[self class] alloc] initWithCurrencyPair:_currencyPair timeFrame:_timeFrame indicatorChunk:_indicatorChunk];
            [self.previousEntityChart strokeForForexDataChunk:newForexDataChunk];
            self.previousEntityChart.visibleViewDefaultStartForexData = leftEndForexData;
        }
    }];
}

- (void)prepareNextEntityChartForMarket:(Market *)market
{
    if (_isStartedPrepareNextEntityChart) {
        return;
    }
    
    _isStartedPrepareNextEntityChart = YES;
    
    NSOperationQueue *queue = [NSOperationQueue new];
    
    [queue addOperationWithBlock:^{
        @synchronized (_syncNextEntityChart) {
            ForexHistoryData *rightEndForexData = [_candle rightEndForexData];
            ForexDataChunk *newForexDataChunk = [market chunkForCenterForexData:rightEndForexData frontLimit:FXSFrontLimitForPrepare backLimit:FXSBackLimitForPrepare];
            
            NSComparisonResult result = [rightEndForexData.latestTime compareTime:newForexDataChunk.latestTime];
            
            if (result != NSOrderedAscending) {
                return;
            }
            
            self.nextEntityChart = [[[self class] alloc] initWithCurrencyPair:_currencyPair timeFrame:_timeFrame indicatorChunk:_indicatorChunk];
            [self.nextEntityChart strokeForForexDataChunk:newForexDataChunk];
            self.nextEntityChart.visibleViewDefaultEndForexData = rightEndForexData;
        }
    }];
}

- (Rate *)maxRate
{
    if (!_maxRate) {
        _maxRate = [_forexDataChunkOfEntityChart getMaxRate];
    }
    
    return _maxRate;
}

- (Rate *)minRate
{
    if (!_minRate) {
        _minRate = [_forexDataChunkOfEntityChart getMinRate];
    }
    
    return _minRate;
}

- (EntityChart *)previousEntityChart
{
    // prepareのsynchronizedより先に、このsynchronizedが実行される可能性がある。(間隔が極めて短い時など)
    /*if (_isStartedPreparePreviousEntityChart) {
        [NSThread sleepForTimeInterval:0.01];
    }*/

    @synchronized (_syncPreviousEntityChart) {
        return _previousEntityChart;
    }
}

- (EntityChart *)nextEntityChart
{
    @synchronized (_syncNextEntityChart) {
        return _nextEntityChart;
    }
}

- (Coordinate *)leftEndForexDataX
{
    return _candle.leftEndForexDataX;
}

- (Coordinate *)rightEndForexDataX
{
    return _candle.rightEndForexDataX;
}

- (Coordinate *)visibleViewDefaultStartX
{
    if (!self.visibleViewDefaultStartForexData) {
        return nil;
    }
    
    CoordinateRange *area = [_candle chartAreaOfForexData:self.visibleViewDefaultStartForexData];
    
    if (area) {
        return area.begin;
    } else {
        return nil;
    }
}

- (Coordinate *)visibleViewDefaultEndX
{
    if (!self.visibleViewDefaultEndForexData) {
        return 0;
    }
    
    CoordinateRange *area = [_candle chartAreaOfForexData:self.visibleViewDefaultEndForexData];
    
    if (area) {
        return area.end;
    } else {
        return nil;
    }
}

- (CGSize)imageSize
{
    if (_isMiniChart) {
        return FXSMiniEntityChartImageSize;
    } else {
        return FXSEntityChartImageSize;
    }
        
}

- (NSUInteger)displayDataCount
{
    if (_isMiniChart) {
        return FXSMiniEntityChartForexDataCount;
    } else {
        return FXSEntityChartForexDataCount;
    }
}

@end
