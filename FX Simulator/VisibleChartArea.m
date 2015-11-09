//
//  VisibleChartArea.m
//  FXSimulator
//
//  Created by yuu on 2015/10/18.
//
//

#import "VisibleChartArea.h"

#import "Coordinate.h"
#import "EntityChart.h"
#import "ForexDataChunk.h"
#import "Rate.h"

// 偶数
static const NSUInteger FXSDefaultDisplayDataCount = 60;
static const NSUInteger FXSMinDisplayDataCount = 60;
static const NSUInteger FXSMaxDisplayDataCount = 100;
static const float FXSEntityChartViewPrepareTotalRangeRatio = 0.5;

@interface VisibleChartArea ()
@property (nonatomic) NSUInteger displayDataCount;
@property (nonatomic) float visibleWidthRatio;
@end

@implementation VisibleChartArea {
    __weak UIScrollView *_visibleChartView;
    __weak UIImageView *_entityChartView;
    CGPoint _normalizedChartScrollViewOffset;
    BOOL _inScale;
    float _scaleX;
    float _previousScaleX;
}

- (instancetype)initWithVisibleChartView:(UIScrollView *)visibleChartView entityChartView:(UIImageView *)entityChartView displayDataCount:(NSUInteger)displayDataCount
{
    if (self = [super init]) {
        _visibleChartView = visibleChartView;
        _visibleChartView.contentInset = UIEdgeInsetsMake(0, [self entityChartViewMargin], 0, [self entityChartViewMargin]);
        _entityChartView = entityChartView;
        _displayDataCount = displayDataCount;
        _visibleWidthRatio = (float)self.displayDataCount / (float)[EntityChart forexDataCount];
    }
    
    return self;
}

- (void)chartScrollViewDidScroll
{
    [self normalize];
}

- (void)scaleStart
{
    _inScale = YES;
    _scaleX = _entityChartView.transform.a;
    _previousScaleX = 1;
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
    
    float startVisibleViewOfEntityChart = (_visibleChartView.contentOffset.x - _entityChartView.frame.origin.x) / _entityChartView.transform.a;
    float endVisibleViewOfEntityChart = startVisibleViewOfEntityChart + (_visibleChartView.frame.size.width / _entityChartView.transform.a);;
    // EntityChart(scale前)で現在表示されている範囲の中間(x)
    float centerLineXOfEntityChart = (startVisibleViewOfEntityChart + endVisibleViewOfEntityChart) / 2;
    
    float normalizedStartX = centerLineXOfEntityChart - (newVisibleViewWidth / 2);
    float normalizedEndX = centerLineXOfEntityChart + (newVisibleViewWidth / 2);
    
    [self visibleForStartXOfEntityChart:normalizedStartX endXOfEntityChart:normalizedEndX];
    
    self.visibleWidthRatio = (normalizedEndX - normalizedStartX) / (_entityChartView.frame.size.width / _entityChartView.transform.a);
}

- (void)scaleEnd
{
    _inScale = NO;
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

- (BOOL)isInPreparePreviousChartRange
{
    if (_visibleChartView.contentOffset.x <= [self preparePreviousChartRangeStartX]) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isInPrepareNextChartRange
{
    if ([self prepareNextChartRangeStartX] <= (_visibleChartView.contentOffset.x + _visibleChartView.frame.size.width)) {
        return YES;
    } else {
        return NO;
    }
}

- (float)entityChartViewLeftEndOfVisibleChartCoordinate
{
    return _entityChartView.frame.origin.x + (self.currentEntityChart.leftEndForexDataX.value * _entityChartView.transform.a);
}

- (float)entityChartViewRightEndOfVisibleChartCoordinate
{
    return  _entityChartView.frame.origin.x + (self.currentEntityChart.rightEndForexDataX.value * _entityChartView.transform.a);
}

- (BOOL)isOverLeftEnd
{
    if (_visibleChartView.contentOffset.x < [self entityChartViewLeftEndOfVisibleChartCoordinate]) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isOverRightEnd
{
    if ([self entityChartViewRightEndOfVisibleChartCoordinate] < (_visibleChartView.contentOffset.x + _visibleChartView.frame.size.width)) {
        return YES;
    } else {
        return NO;
    }
}

- (float)preparePreviousChartRangeStartX
{
    return _visibleChartView.frame.origin.x + _entityChartView.frame.origin.x + [self prepareRangeWidth];
}

- (float)prepareNextChartRangeStartX
{
    return _visibleChartView.frame.origin.x + _entityChartView.frame.origin.x + _entityChartView.frame.size.width - [self prepareRangeWidth];
}

- (float)prepareRangeWidth
{
    return _entityChartView.frame.size.width * FXSEntityChartViewPrepareTotalRangeRatio / 2;
}

- (float)entityChartViewMargin
{
    return _visibleChartView.frame.size.width * 0.25;
}

- (void)normalize
{
    float startVisibleViewOfEntityChart = (_visibleChartView.contentOffset.x - _entityChartView.frame.origin.x) / _entityChartView.transform.a;
    float endVisibleViewOfEntityChart = startVisibleViewOfEntityChart + (_visibleChartView.frame.size.width / _entityChartView.transform.a);
    
    [self visibleForStartXOfEntityChart:startVisibleViewOfEntityChart endXOfEntityChart:endVisibleViewOfEntityChart];
}

- (ForexHistoryData *)forexDataOfVisibleChartViewPoint:(CGPoint)point
{
    float entityChartViewX = (_visibleChartView.contentOffset.x + point.x) / _entityChartView.transform.a;
    float entityChartViewY = (_visibleChartView.contentOffset.y + point.y) / _entityChartView.transform.d;
    
    return [self.currentEntityChart forexDataOfEntityChartPoint:CGPointMake(entityChartViewX, entityChartViewY)];
}

- (void)visibleForRightEndOfEntityChart
{
    float startX = _entityChartView.frame.size.width - (_entityChartView.frame.size.width * self.visibleWidthRatio);
    float endX = startX + (_entityChartView.frame.size.width * self.visibleWidthRatio);
    
    [self visibleForStartXOfEntityChart:startX endXOfEntityChart:endX];
}

- (void)visibleForStartXOfEntityChart:(float)startX
{
    float endX = startX + (_entityChartView.frame.size.width * self.visibleWidthRatio);
    
    [self visibleForStartXOfEntityChart:startX endXOfEntityChart:endX];
}

- (void)visibleForEndXOfEntityChart:(float)endX
{
    float startX = endX - (_entityChartView.frame.size.width * self.visibleWidthRatio);
    
    [self visibleForStartXOfEntityChart:startX endXOfEntityChart:endX];
}

- (void)visibleForStartXOfEntityChart:(float)startX endXOfEntityChart:(float)endX
{
    _entityChartView.transform = CGAffineTransformIdentity;
    
    ForexDataChunk *visibleForexDataChunk = [self.currentEntityChart chunkForRangeStartX:startX endX:endX];
    
    if (!visibleForexDataChunk.count || !self.currentEntityChart.maxRate || !self.currentEntityChart.minRate) {
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
    
    double entityChartMaxRate = self.currentEntityChart.maxRate.rateValue;
    // scale後のEntityChartでの1pipあたりの画面サイズ(Y)
    float onePipEntityChartViewDisplaySize = _entityChartView.frame.size.height / differenceEntityChartMaxMinRate;
    // 表示されているチャートの中で最大のレートが、EntityChartでどの位置(Y)にあるのか
    float visibleChartMaxRateYOfEntityChart = (entityChartMaxRate - visibleChartMaxRate) * onePipEntityChartViewDisplaySize;
    
    float entityChartViewLeftEnd = self.currentEntityChart.leftEndForexDataX.value * _entityChartView.transform.a;
    
    _entityChartView.frame = CGRectMake(-entityChartViewLeftEnd, 0, _entityChartView.frame.size.width, _entityChartView.frame.size.height);
    _normalizedChartScrollViewOffset = CGPointMake((startX - self.currentEntityChart.leftEndForexDataX.value) * _entityChartView.transform.a, visibleChartMaxRateYOfEntityChart);
    _visibleChartView.contentOffset = _normalizedChartScrollViewOffset;
    float entityChartViewRightEnd = self.currentEntityChart.rightEndForexDataX.value * _entityChartView.transform.a;
    _visibleChartView.contentSize = CGSizeMake(entityChartViewRightEnd - entityChartViewLeftEnd, _entityChartView.frame.size.height);
            self.visibleWidthRatio = _visibleChartView.frame.size.width / _entityChartView.frame.size.width;
}

- (void)setCurrentEntityChart:(EntityChart *)currentEntityChart
{
    _currentEntityChart = currentEntityChart;
    _entityChartView.transform = CGAffineTransformIdentity;
    _entityChartView.image = _currentEntityChart.chartImage;
}

- (void)setVisibleWidthRatio:(float)visibleWidthRatio
{
    _visibleWidthRatio = visibleWidthRatio;
    
    self.displayDataCount = [EntityChart forexDataCount] * self.visibleWidthRatio;
}

- (NSUInteger)displayDataCount
{
    if (_displayDataCount == 0) {
        return FXSDefaultDisplayDataCount;
    } else if (_displayDataCount < FXSMinDisplayDataCount) {
        return FXSMinDisplayDataCount;
    } else if (FXSMaxDisplayDataCount < _displayDataCount) {
        return FXSMaxDisplayDataCount;
    }
    
    return _displayDataCount;
}

@end
