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

+(CGPoint)getChartViewPointFromRate:(Rate *)rate ratePointNumber:(NSInteger)num minRate:(Rate *)minRate maxRate:(Rate *)maxRate ratePointCount:(NSInteger)count viewSize:(CGSize)size
{
    float ratePointZoneWidth = size.width / count;
    float positionX = num * ratePointZoneWidth + ratePointZoneWidth / 2;
    
    float subResult = [maxRate subRate:minRate].rateValue;
    float pipDispSize = size.height/subResult;
    float positionY = [maxRate subRate:rate].rateValue * pipDispSize;
    
    return CGPointMake(positionX, positionY);
}

@end
