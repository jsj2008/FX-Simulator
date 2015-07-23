//
//  CandleChart.m
//  FX Simulator
//
//  Created by yuu on 2015/07/05.
//
//

#import "Candle.h"

#import "SimpleCandle.h"
#import "CandlePlistSource.h"
#import "CandlesFactory.h"
#import "ForexDataChunk.h"

@implementation Candle {
    CandlePlistSource *_source;
}

- (instancetype)initWithSource:(IndicatorPlistSource *)source
{
    return nil;
}

- (instancetype)initWithCandleSource:(CandlePlistSource *)source
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
    return _source.sourceDictionary;
}

@end
