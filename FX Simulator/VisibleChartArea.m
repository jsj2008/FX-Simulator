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

- (float)entityChartViewLeftEnd
{
    CALayer *entityChartViewLayer = _entityChartView.layer.presentationLayer;
    
    return entityChartViewLayer.frame.origin.x + (self.currentEntityChart.leftEndForexDataX.value * _entityChartView.transform.a);
}

- (float)entityChartViewRightEnd
{
    CALayer *entityChartViewLayer = _entityChartView.layer.presentationLayer;
    
    return  entityChartViewLayer.frame.origin.x + (self.currentEntityChart.rightEndForexDataX.value * _entityChartView.transform.a);
}

- (BOOL)isOverLeftEnd
{
    if (_visibleChartView.frame.origin.x < [self entityChartViewLeftEnd]) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isOverRightEnd
{
    if ([self entityChartViewRightEnd] < (_visibleChartView.frame.origin.x + _visibleChartView.frame.size.width)) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isOverMoveRangeLeftEnd
{
    if ([self moveRangeLeftEndX] < [self entityChartViewLeftEnd]) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isOverMoveRangeRightEnd
{
    if ([self entityChartViewRightEnd] < [self moveRangeRightEndX]) {
        return YES;
    } else {
        return NO;
    }
}

- (void)setLeftEnd
{
    _entityChartView.frame = CGRectMake(_visibleChartView.frame.origin.x - (self.currentEntityChart.leftEndForexDataX.value * _entityChartView.transform.a), _entityChartView.frame.origin.y, _entityChartView.frame.size.width, _entityChartView.frame.size.height);
}

- (void)setRightEnd
{
    float visibleChartViewEndX = _visibleChartView.frame.origin.x + _visibleChartView.frame.size.width;
    float newEntityChartViewX = visibleChartViewEndX - (self.currentEntityChart.rightEndForexDataX.value * _entityChartView.transform.a);
    
    _entityChartView.frame = CGRectMake(newEntityChartViewX, _entityChartView.frame.origin.y, _entityChartView.frame.size.width, _entityChartView.frame.size.height);
}

- (void)setMoveRangeLeftEnd
{
    float newEntityChartViewX = [self moveRangeLeftEndX] - (self.currentEntityChart.leftEndForexDataX.value * _entityChartView.transform.a);
    
    _entityChartView.frame = CGRectMake(newEntityChartViewX, _entityChartView.frame.origin.y, _entityChartView.frame.size.width, _entityChartView.frame.size.height);
}

- (void)setMoveRangeRightEnd
{
    float newEntityChartViewX = [self moveRangeRightEndX] - (self.currentEntityChart.rightEndForexDataX.value * _entityChartView.transform.a);
    
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

- (void)visibleForStartXOfEntityChart:(float)startX endXOfEntityChart:(float)endX inAnimation:(BOOL)inAnimation
{
    _entityChartView.transform = CGAffineTransformIdentity;
    
    ForexDataChunk *visibleForexDataChunk = [self.currentEntityChart chunkForRangeStartX:startX endX:endX];
    
    if (!visibleForexDataChunk || !self.currentEntityChart.maxRate || !self.currentEntityChart.minRate) {
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
    
    if (inAnimation) {
        _entityChartView.frame = CGRectMake(_entityChartView.frame.origin.x, entityChartViewY, _entityChartView.frame.size.width, _entityChartView.frame.size.height);
    } else {
        _entityChartView.frame = CGRectMake(entityChartViewX, entityChartViewY, _entityChartView.frame.size.width, _entityChartView.frame.size.height);
    }
}

@end
