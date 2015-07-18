//
//  SubChartView.m
//  FX Simulator
//
//  Created  on 2014/11/14.
//  
//

#import "SubChartView.h"

#import "Candle.h"


@implementation SubChartView {
    Candle *_candleChart;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        _displayForexDataCount = 40;
        _candleChart = [Candle new];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{    
    if (self.chunk == nil) {
        return;
    }
    
    [_candleChart strokeIndicatorFromForexDataChunk:self.chunk displayForexDataCount:40 displaySize:self.frame.size];
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
