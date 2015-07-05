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

- (void)strokeIndicatorFromForexDataArray:(ForexDataChunk *)array displayForexDataCount:(NSInteger)count displaySize:(CGSize)size
{
    ForexDataChunk *displayForexDataChunk = [array getForexDataLimit:count];
    
    NSArray *candles = [CandlesFactory createCandlesFromForexHistoryDataChunk:displayForexDataChunk displayForexDataCount:count chartViewWidth:size.width chartViewHeight:size.height];
    
    for (Candle *candle in candles) {
        [candle stroke];
    }
}

@end
