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

- (instancetype)initWithSource:(IndicatorSource *)source
{
    return nil;
}

- (instancetype)initWithCandleSource:(CandleSource *)source
{
    if (self = [super initWithSource:source]) {
        _source = source;
    }
    
    return self;
}

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

- (NSDictionary *)sourceDictionary
{
    return [_source sourceDictionary];
}

@end
