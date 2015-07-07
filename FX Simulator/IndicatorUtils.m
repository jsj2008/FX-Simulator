//
//  TechnicalUtils.m
//  FX Simulator
//
//  Created by yuu on 2015/07/04.
//
//

#import "IndicatorUtils.h"

#import "Rate.h"

@implementation IndicatorUtils

+ (CGPoint)getChartViewPointFromRate:(Rate *)rate ratePointNumber:(NSInteger)num minRate:(double)minRate maxRate:(double)maxRate ratePointCount:(NSInteger)count viewSize:(CGSize)size
{
    float ratePointZoneWidth = size.width / count;
    // RatePointZoneの真ん中に、表示する。
    float positionX = size.width - (num * ratePointZoneWidth + ratePointZoneWidth / 2);
    
    float subResult = maxRate - minRate;
    float pipDispSize = size.height/subResult;
    float positionY = (maxRate - rate.rateValue) * pipDispSize;
    
    return CGPointMake(positionX, positionY);
}

+ (CGPoint)getMiddlePoint:(CGPoint)p1 nextPoint:(CGPoint)p2
{
    return CGPointMake((p1.x + p2.x) * 0.5, (p1.y + p2.y) * 0.5);
}

@end
