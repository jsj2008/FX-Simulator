//
//  CandleChart.m
//  FX Simulator
//
//  Created by yuu on 2015/07/05.
//
//

#import "Candle.h"

#import "SimpleCandle.h"
#import "CandleSource.h"
#import "CandlesFactory.h"
#import "ForexDataChunk.h"

@implementation Candle {
    CandleSource *_source;
}

- (instancetype)initWithIndicatorSource:(IndicatorSource *)source
{
    return nil;
}

- (instancetype)initWithCandleSource:(CandleSource *)source
{
    if (self = [super initWithIndicatorSource:source]) {
        _source = source;
    }
    
    return self;
}

/*- (instancetype)initWithDefaultCandle
{
    UIColor *upColor = [UIColor colorWithRed:35.0/255.0 green:172.0/255.0 blue:14.0/255.0 alpha:1.0];
    UIColor *downColor = [UIColor colorWithRed:199.0/250.0 green:36.0/255.0 blue:58.0/255.0 alpha:1.0];
}*/

- (void)strokeIndicatorFromForexDataChunk:(ForexDataChunk *)chunk displayForexDataCount:(NSInteger)count displaySize:(CGSize)size
{
    if (chunk == nil) {
        return;
    }
    
    NSArray *candles = [CandlesFactory createCandlesFromForexHistoryDataChunk:chunk displayForexDataCount:count chartViewWidth:size.width chartViewHeight:size.height];
    
    for (SimpleCandle *candle in candles) {
        [candle stroke];
    }
}

@end
