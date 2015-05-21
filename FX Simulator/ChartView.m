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
#import "CandlesFactory.h"

@implementation ChartView

/*-(id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.backgroundColor = [UIColor colorWithRed:197/255.0 green:197/255.0 blue:200/255.0 alpha:0.0];
    }
    return self;
}*/

/*-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [self initWithCoder:aDecoder]) {
        NSLog(@"view");
    }
    
    return self;
}*/

-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //NSLog(@"ChartView %f %f", self.frame.size.width, self.frame.size.height);
    
    NSArray *candles = [CandlesFactory createCandlesFromForexHistoryDataArray:self.chartDataArray chartViewWidth:self.frame.size.width chartViewHeight:self.frame.size.height];
    
    for (Candle *candle in candles) {
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
        
        // candle
        CGContextSetLineWidth(context, 0.0);
        CGContextSetRGBStrokeColor(context, 0, 0, 0, 0);
        CGContextStrokeRect(context, CGRectMake(candlePositionX, candlePositionY, candleWidth, candleHeight));
        CGContextSetRGBFillColor(context, colorR, colorG, colorB, 1.0);
        CGContextFillRect(context, CGRectMake(candlePositionX, candlePositionY, candleWidth, candleHeight));
        
        // candle high-low line
        CGContextSetLineWidth(context, 2.0);
        CGContextSetRGBStrokeColor(context, colorR, colorG, colorB, 1);
        CGContextMoveToPoint(context, highLineBottom.x, highLineBottom.y);
        CGContextAddLineToPoint(context, highLineTop.x, highLineTop.y);
        CGContextMoveToPoint(context, lowLineTop.x, lowLineTop.y);
        CGContextAddLineToPoint(context, lowLineBottom.x, lowLineBottom.y);
        CGContextStrokePath(context);
    }

}

@end
