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
#import "SimpleMovingAverageSource.h"


@implementation ChartView {
    CandleChart *_candleChart;
    SimpleMovingAverage *_simpleMA;
    SimpleMovingAverage *_simpleMA2;
    SimpleMovingAverage *_simpleMA3;
    SimpleMovingAverage *_simpleMA4;
    SimpleMovingAverage *_simpleMA5;
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
        SimpleMovingAverageSource *s1 = [SimpleMovingAverageSource new];
        SimpleMovingAverageSource *s2 = [SimpleMovingAverageSource new];
        SimpleMovingAverageSource *s3 = [SimpleMovingAverageSource new];
        SimpleMovingAverageSource *s4 = [SimpleMovingAverageSource new];
        SimpleMovingAverageSource *s5 = [SimpleMovingAverageSource new];
        s1.term = 20;
        s1.lineColor = [UIColor whiteColor];
        s2.term = 50;
        s2.lineColor = [UIColor whiteColor];
        s3.term = 75;
        s3.lineColor = [UIColor whiteColor];
        s4.term = 100;
        s4.lineColor = [UIColor whiteColor];
        s5.term = 200;
        s5.lineColor = [UIColor whiteColor];
        _simpleMA = [[SimpleMovingAverage alloc] initWithSource:s1];
        _simpleMA2 = [[SimpleMovingAverage alloc] initWithSource:s2];
        _simpleMA3 = [[SimpleMovingAverage alloc] initWithSource:s3];
        _simpleMA4 = [[SimpleMovingAverage alloc] initWithSource:s4];
        _simpleMA5 = [[SimpleMovingAverage alloc] initWithSource:s5];
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
    [_simpleMA2 strokeIndicatorFromForexDataChunk:self.chartDataChunk displayForexDataCount:40 displaySize:self.frame.size];
    [_simpleMA3 strokeIndicatorFromForexDataChunk:self.chartDataChunk displayForexDataCount:40 displaySize:self.frame.size];
    [_simpleMA4 strokeIndicatorFromForexDataChunk:self.chartDataChunk displayForexDataCount:40 displaySize:self.frame.size];
    [_simpleMA5 strokeIndicatorFromForexDataChunk:self.chartDataChunk displayForexDataCount:40 displaySize:self.frame.size];
}

@end
