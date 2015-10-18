//
//  VisibleChartArea.m
//  FXSimulator
//
//  Created by yuu on 2015/10/18.
//
//

#import "VisibleChartArea.h"

#import "EntityChart.h"
#import "ForexDataChunk.h"
#import "Rate.h"

static const float FXSEntityChartViewPrepareTotalRangeRatio = 0.5;

@implementation VisibleChartArea {
    UIView *_visibleChartView;
    UIImageView *_entityChartView;
}

- (instancetype)initWithVisibleChartView:(UIView *)visibleChartView entityChartView:(UIImageView *)entityChartView
{
    if (self = [super init]) {
        _visibleChartView = visibleChartView;
        _entityChartView = entityChartView;
    }
    
    return self;
}

- (BOOL)isInPreparePreviousChartRange
{
    if (_visibleChartView.frame.origin.x <= [self preparePreviousChartRangeStartX]) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isInPrepareNextChartRange
{
    float visibleChartViewEndX = _visibleChartView.frame.origin.x + _visibleChartView.frame.size.width;
    
    if ([self prepareNextChartRangeStartX] <= visibleChartViewEndX) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isOverLeftEnd
{
    CALayer *entityChartViewLayer = _entityChartView.layer.presentationLayer;
    
    if (_visibleChartView.frame.origin.x < entityChartViewLayer.frame.origin.x) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isOverRightEnd
{
    CALayer *entityChartViewLayer = _entityChartView.layer.presentationLayer;
    
    if ((entityChartViewLayer.frame.origin.x + entityChartViewLayer.frame.size.width) < (_visibleChartView.frame.origin.x + _visibleChartView.frame.size.width)) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isOverMoveRangeLeftEnd
{
    float entityChartViewX = _entityChartView.frame.origin.x;
    
    if ([self moveRangeLeftEndX] < entityChartViewX) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isOverMoveRangeRightEnd
{
    float entityChartViewEndX = _entityChartView.frame.origin.x + _entityChartView.frame.size.width;
    
    if (entityChartViewEndX < [self moveRangeRightEndX]) {
        return YES;
    } else {
        return NO;
    }
}

- (void)setMoveRangeLeftEnd
{
    float newEntityChartViewX = [self moveRangeLeftEndX];
    
    _entityChartView.frame = CGRectMake(newEntityChartViewX, _entityChartView.frame.origin.y, _entityChartView.frame.size.width, _entityChartView.frame.size.height);
}

- (void)setMoveRangeRightEnd
{
    float newEntityChartViewX = [self moveRangeRightEndX] - _entityChartView.frame.size.width;
    
    _entityChartView.frame = CGRectMake(newEntityChartViewX, _entityChartView.frame.origin.y, _entityChartView.frame.size.width, _entityChartView.frame.size.height);
}

- (float)moveRangeLeftEndX
{
    return _visibleChartView.frame.origin.x + [self maxMarginOfVisibleChartViewAndEntityChartView];
}

- (float)moveRangeRightEndX
{
    float visibleChartViewEndX = _visibleChartView.frame.origin.x + _visibleChartView.frame.size.width;
    
    return visibleChartViewEndX - [self maxMarginOfVisibleChartViewAndEntityChartView];
}

- (float)maxMarginOfVisibleChartViewAndEntityChartView
{
    return _visibleChartView.frame.size.width / 4;
}

- (float)preparePreviousChartRangeStartX
{
    CALayer *entityChartViewLayer = _entityChartView.layer.presentationLayer;
    
    return entityChartViewLayer.frame.origin.x + [self prepareRangeWidth];
}

- (float)prepareNextChartRangeStartX
{
    CALayer *entityChartViewLayer = _entityChartView.layer.presentationLayer;
    
    float entityChartViewRightEndX = entityChartViewLayer.frame.origin.x + entityChartViewLayer.frame.size.width;
    
    return entityChartViewRightEndX - [self prepareRangeWidth];
}

- (float)prepareRangeWidth
{
    return _entityChartView.frame.size.width * FXSEntityChartViewPrepareTotalRangeRatio / 2;
}

- (void)visibleForStartXOfEntityChart:(float)startX endXOfEntityChart:(float)endX entityChart:(EntityChart *)entityChart inAnimation:(BOOL)inAnimation
{
    if (startX < 0) {
        return;
    }
    
    _entityChartView.transform = CGAffineTransformIdentity;
    
    ForexDataChunk *visibleForexDataChunk = [entityChart chunkForRangeStartX:startX endX:endX];
    
    if (!visibleForexDataChunk) {
        return;
    }
    
    float scaleX = _visibleChartView.frame.size.width / (endX - startX);
    
    double differenceEntityChartMaxMinRate = entityChart.maxRate.rateValue - entityChart.minRate.rateValue;
    double visibleChartMaxRate = [visibleForexDataChunk getMaxRate].rateValue;
    double visibleChartMinRate = [visibleForexDataChunk getMinRate].rateValue;
    double differenceVisibleChartMaxMinRate = visibleChartMaxRate - visibleChartMinRate;
    // scale後のEntityChartの高さ。
    float scaledEntityChartViewHeight = _visibleChartView.frame.size.height / (differenceVisibleChartMaxMinRate / differenceEntityChartMaxMinRate);
    // 元のEntityChartからどれだけscaleするのか。
    float scaleY = scaledEntityChartViewHeight / _entityChartView.frame.size.height;
    
    _entityChartView.transform = CGAffineTransformMakeScale(scaleX, scaleY);
    
    float entityChartViewX = _visibleChartView.frame.origin.x - (startX * _entityChartView.transform.a);
    
    double entityChartMaxRate = entityChart.maxRate.rateValue;
    // scale後のEntityChartでの1pipあたりの画面サイズ(Y)
    float onePipEntityChartViewDisplaySize = _entityChartView.frame.size.height / differenceEntityChartMaxMinRate;
    // 表示されているチャートの中で最大のレートが、EntityChartでどの位置(Y)にあるのか
    float visibleChartMaxRateYOfEntityChart = (entityChartMaxRate - visibleChartMaxRate) * onePipEntityChartViewDisplaySize;
    float entityChartViewY = _visibleChartView.frame.origin.y - visibleChartMaxRateYOfEntityChart;
    
    if (inAnimation) {
        _entityChartView.frame = CGRectMake(_entityChartView.frame.origin.x, entityChartViewY, _entityChartView.frame.size.width, _entityChartView.frame.size.height);
    } else {
        _entityChartView.frame = CGRectMake(entityChartViewX, entityChartViewY, _entityChartView.frame.size.width, _entityChartView.frame.size.height);
    }
}

@end
