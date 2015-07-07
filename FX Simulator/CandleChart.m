//
//  CandleChart.m
//  FX Simulator
//
//  Created by yuu on 2015/07/05.
//
//

#import "CandleChart.h"

#import "Candle.h"
#import "CandlesFactory.h"
#import "ForexDataChunk.h"

@implementation CandleChart

- (void)strokeIndicatorFromForexDataChunk:(ForexDataChunk *)chunk displayForexDataCount:(NSInteger)count displaySize:(CGSize)size
{
    NSArray *candles = [CandlesFactory createCandlesFromForexHistoryDataChunk:chunk displayForexDataCount:count chartViewWidth:size.width chartViewHeight:size.height];
    
    for (Candle *candle in candles) {
        [candle stroke];
    }
}

@end
