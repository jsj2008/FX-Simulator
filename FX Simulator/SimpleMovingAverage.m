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
#import "SimpleMovingAverageSource.h"

@implementation SimpleMovingAverage {
    NSUInteger _term;
    UIColor *_lineColor;
}

-(instancetype)init
{
    return nil;
}

- (instancetype)initWithSource:(SimpleMovingAverageSource *)source
{
    if (self = [super initWithSource:source]) {
        _source = source;
        _term = _source.term;
        _lineColor = _source.lineColor;
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

+ (NSString *)indicatorName
{
    return @"SimpleMovingAverage";
}

@end
