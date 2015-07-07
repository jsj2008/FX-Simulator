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
#import "SimpleMovingAverage.h"


@implementation ChartView {
    CandleChart *_candleChart;
    SimpleMovingAverage *_simpleMA;
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
        _simpleMA = [SimpleMovingAverage new];
        _chartDataChunk = [ForexDataChunk new];
    }
    
    return self;
}

-(void)drawRect:(CGRect)rect
{    
    if (self.chartDataChunk == nil) {
        return;
    }
    
    [_candleChart strokeIndicatorFromForexDataChunk:self.chartDataChunk displayForexDataCount:40 displaySize:self.frame.size];
    [_simpleMA strokeIndicatorFromForexDataChunk:self.chartDataChunk displayForexDataCount:40 displaySize:self.frame.size];
}

@end
