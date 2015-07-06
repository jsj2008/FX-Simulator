//
//  Chart.m
//  ForexGame
//
//  Created  on 2014/04/03.
//  
//

#import "ChartView.h"

#import "ForexHistoryData.h"
#import "Candle.h"
#import "CandleChart.h"
#import "CandlesFactory.h"
#import "ForexDataChunk.h"
#import "IndicatorUtils.h"


@implementation ChartView {
    CandleChart *_candleChart;
}

/*-(id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.backgroundColor = [UIColor colorWithRed:197/255.0 green:197/255.0 blue:200/255.0 alpha:0.0];
    }
    return self;
}*/

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        _candleChart = [CandleChart new];
        _chartDataChunk = [ForexDataChunk new];
    }
    
    return self;
}

-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (self.chartDataChunk == nil) {
        return;
    }
    
    [_candleChart strokeIndicatorFromForexDataChunk:self.chartDataChunk displayForexDataCount:40 displaySize:self.frame.size];
    
    //NSArray *candles = [CandlesFactory createCandlesFromForexHistoryDataArray:self.chartDataArray chartViewWidth:self.frame.size.width chartViewHeight:self.frame.size.height];
    
    /*Rate *minRate = self.chartDataArray.minRate;
    Rate *maxRate = self.chartDataArray.maxRate;
    int ratePointCount = self.chartDataArray.array.count;
    
    CGPoint previousPoint = [IndicatorUtils getChartViewPointFromRate:((ForexHistoryData*)[self.chartDataArray.array objectAtIndex:0]).close ratePointNumber:0 minRate:minRate maxRate:maxRate ratePointCount:ratePointCount viewSize:self.frame.size];
    UIBezierPath *path     = [UIBezierPath bezierPath];
    path.lineWidth         = 2;
    [[UIColor whiteColor] setStroke];
    [path moveToPoint:previousPoint];*/
    //UIBezierPath *path     = [UIBezierPath bezierPath];
    //for (Candle *candle in candles) {
    //for (int i = 2; i < candles.count; i++) {
    /*CGPoint currentPoint;
    CGPoint midPoint;
    CGPoint previousPoint1;*/
    //for (int i = 1; i < ratePointCount; i = i + 1) {
        
        /*if (i % 2) {
            [[UIColor whiteColor] setStroke];
        } else {
            [[UIColor blueColor] setStroke];
        }*/
        //CGPoint previousPoint2 = ((Candle*)[candles objectAtIndex:i - 2]).rect.origin;
        //CGPoint previousPoint2 = [TechnicalUtils getChartViewPointFromRate:((ForexHistoryData*)[self.chartDataArray.array objectAtIndex:i-2]).close ratePointNumber:i-2 minRate:minRate maxRate:maxRate ratePointCount:ratePointCount viewSize:self.frame.size];
        /*previousPoint1 = [IndicatorUtils getChartViewPointFromRate:((ForexHistoryData*)[self.chartDataArray.array objectAtIndex:i-1]).close ratePointNumber:i-1 minRate:minRate maxRate:maxRate ratePointCount:ratePointCount viewSize:self.frame.size];
        currentPoint   = [IndicatorUtils getChartViewPointFromRate:((ForexHistoryData*)[self.chartDataArray.array objectAtIndex:i]).close ratePointNumber:i minRate:minRate maxRate:maxRate ratePointCount:ratePointCount viewSize:self.frame.size];
        
        midPoint = [self midPoint:previousPoint1 nextPoint:currentPoint];*/
        //[path moveToPoint:previousPoint2];
        //[path addQuadCurveToPoint:midPoint controlPoint:previousPoint1];
        //[path addQuadCurveToPoint:currentPoint controlPoint:midPoint];
        /*Candle *candle = candles[i];
        CGRect candleRect = candle.rect;
        float candlePositionX = candleRect.origin.x;
        float candlePositionY = candleRect.origin.y;
        float candleWidth = candleRect.size.width;
        float candleHeight = candleRect.size.height;
        CGPoint highLineTop = candle.highLineTop;
        CGPoint highLineBottom = candle.highLineBottom;
        CGPoint lowLineTop = candle.lowLineTop;
        CGPoint lowLineBottom = candle.lowLineBottom;
        float colorR = candle.colorR;
        float colorG = candle.colorG;
        float colorB = candle.colorB;
        
        [[UIColor whiteColor] setStroke];
        UIBezierPath *path     = [UIBezierPath bezierPath];
        path.lineWidth         = 2;
        CGPoint previousPoint2 = ((Candle*)[candles objectAtIndex:i - 2]).rect.origin;
        CGPoint previousPoint1 = ((Candle*)[candles objectAtIndex:i - 1]).rect.origin;
        CGPoint currentPoint   = ((Candle*)[candles objectAtIndex:i]).rect.origin;
        
        CGPoint midPoint = [self midPoint:previousPoint1 nextPoint:currentPoint];
        [path moveToPoint:previousPoint1];
        [path addQuadCurveToPoint:currentPoint controlPoint:midPoint];*/
        
        // ２つ前の中間点
        //CGPoint mid1           = [self midPoint:previousPoint1 nextPoint:previousPoint2];
        // １つ前の中間点
        //CGPoint mid2           = [self midPoint:currentPoint nextPoint:previousPoint1];
        // ２つ前の中間点から
        //[path moveToPoint:mid1];
        // １つ前の点を支点として、１つ前の中間点まで描画
        //[path addQuadCurveToPoint:mid2 controlPoint:previousPoint1];
        
        //[path stroke];
        
        // candle
        /*CGContextSetLineWidth(context, 0.0);
        CGContextSetRGBStrokeColor(context, 0, 0, 0, 0);
        CGContextStrokeRect(context, CGRectMake(candlePositionX, candlePositionY, candleWidth, candleHeight));
        CGContextSetRGBFillColor(context, colorR, colorG, colorB, 1.0);
        CGContextFillRect(context, CGRectMake(candlePositionX, candlePositionY, candleWidth, candleHeight));*/
        
        // candle high-low line
        /*CGContextSetLineWidth(context, 2.0);
        CGContextSetRGBStrokeColor(context, colorR, colorG, colorB, 1);
        CGContextMoveToPoint(context, highLineBottom.x, highLineBottom.y);
        CGContextAddLineToPoint(context, highLineTop.x, highLineTop.y);
        CGContextMoveToPoint(context, lowLineTop.x, lowLineTop.y);
        CGContextAddLineToPoint(context, lowLineBottom.x, lowLineBottom.y);
        CGContextStrokePath(context);*/
    //}
    
    //[path addQuadCurveToPoint:currentPoint controlPoint:];
    
    
    
    //[path stroke];

}

-(CGPoint)midPoint:(CGPoint)p1 nextPoint:(CGPoint)p2
{
    return CGPointMake((p1.x + p2.x) * 0.5, (p1.y + p2.y) * 0.5);
}

@end
