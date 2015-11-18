//
//  SimpleMovingAverage.m
//  FX Simulator
//
//  Created by yuu on 2015/07/04.
//
//

#import "MovingAverage.h"

#import "MovingAverageSource.h"
#import "ForexDataChunk.h"
#import "IndicatorUtils.h"
#import "Rate.h"

@implementation MovingAverage {
    MovingAverageSource *_source;
}

-(instancetype)init
{
    return nil;
}

- (instancetype)initWithMovingAverageSource:(MovingAverageSource *)source
{
    if (self = [super initWithIndicatorSource:source]) {
        _source = source;
    }
    
    return self;
}

- (void)strokeIndicatorFromForexDataChunk:(ForexDataChunk *)chunk displayForexDataCount:(NSInteger)count displaySize:(CGSize)size
{
    if (chunk == nil) {
        return;
    }
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = 2;
    [self.lineColor setStroke];
    
    __block CGPoint previousLoaded;
    
    [chunk enumerateForexDataAndAverageRatesUsingBlock:^(ForexHistoryData *obj, NSUInteger idx, Rate *average) {
        CGPoint p = [IndicatorUtils getChartViewPointFromRate:average ratePointNumber:idx minRate:[chunk getMinRateLimit:count] maxRate:[chunk getMaxRateLimit:count] ratePointCount:count viewSize:size];
        
        if (idx == 0) {
            [path moveToPoint:p];
        } else {
            CGPoint mid = [IndicatorUtils getMiddlePoint:previousLoaded nextPoint:p];
            [path addQuadCurveToPoint:mid controlPoint:p];
        }
        
        previousLoaded = p;
        
    } averageTerm:self.period limit:count];
    
    [path stroke];
}

#pragma mark - getter,setter

- (NSUInteger)period
{
    return _source.period;
}

- (void)setPeriod:(NSUInteger)period
{
    _source.period = (int)period;
}

- (UIColor *)lineColor
{
    return _source.lineColor;
}

- (void)setLineColor:(UIColor *)lineColor
{
    _source.lineColor = lineColor;
}

@end
