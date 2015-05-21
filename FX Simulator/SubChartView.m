//
//  SubChartView.m
//  FX Simulator
//
//  Created  on 2014/11/14.
//  
//

#import "SubChartView.h"
//#import "CandlesFactory.h"
#import "Candle.h"
//#import "ForexHistoryData.h"

@implementation SubChartView {
    //NSArray *_chartDataArray;
    //NSArray *candles;
}

/*-(id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.backgroundColor = [UIColor colorWithRed:197/255.0 green:197/255.0 blue:200/255.0 alpha:0.0];
    }
    return self;
}*/

-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //candles = [CandlesFactory createCandlesFromForexHistoryDataArray:_chartDataArray chartViewWidth:self.frame.size.width chartViewHeight:self.frame.size.height];
    
    for (Candle *candle in _candles) {
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

/*-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint pt = [[touches anyObject] locationInView:self];
    
    for (id<Candle> candle in candles) {
        if (CGRectContainsPoint(candle.rect,pt)) {
            id<ForexHistoryData> forexHistoryData = candle.forexHistoryData;
            NSTimeInterval interval = forexHistoryData.openTimestamp;
            NSDate* expiresDate = [NSDate dateWithTimeIntervalSince1970:interval];
            NSLog(@"expiresDate: %@", expiresDate);
        }
    }
    
}*/

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
