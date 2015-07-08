//
//  SimpleMovingAverage.m
//  FX Simulator
//
//  Created by yuu on 2015/07/04.
//
//

#import "SimpleMovingAverage.h"

#import "ForexDataChunk.h"
#import "IndicatorUtils.h"
#import "Rate.h"

@implementation SimpleMovingAverage {
    NSUInteger _term;
    UIColor *_lineColor;
}

-(instancetype)init
{
    if (self = [super init]) {
        _term = 20;
        _lineColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void)strokeIndicatorFromForexDataChunk:(ForexDataChunk *)chunk displayForexDataCount:(NSInteger)count displaySize:(CGSize)size
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = 2;
    [_lineColor setStroke];
    
    __block CGPoint previousLoaded;
    
    [chunk enumerateObjectsAndAverageRatesUsingBlock:^(ForexHistoryData *obj, NSUInteger idx, Rate *average) {
        CGPoint p = [IndicatorUtils getChartViewPointFromRate:average ratePointNumber:idx minRate:[chunk getMinRateLimit:count] maxRate:[chunk getMaxRateLimit:count] ratePointCount:count viewSize:size];
        
        if (idx == 0) {
            [path moveToPoint:p];
        } else {
            CGPoint mid = [IndicatorUtils getMiddlePoint:previousLoaded nextPoint:p];
            [path addQuadCurveToPoint:mid controlPoint:p];
        }
        
        previousLoaded = p;
        
    } averageTerm:_term limit:count resultReverse:NO];
    
    [path stroke];
}

@end
