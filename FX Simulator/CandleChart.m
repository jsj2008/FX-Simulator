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
#import "ForexDataArray.h"

@implementation CandleChart

- (void)strokeIndicatorFromForexDataArray:(ForexDataArray *)array displayPointCount:(NSInteger)count displaySize:(CGSize)size
{
    NSArray *displayForexData = [array getForexDataLimit:count];
    
    NSArray *candles = [CandlesFactory createCandlesFromForexHistoryDataArray:displayForexData chartViewWidth:size.width chartViewHeight:size.height];
    
    for (Candle *candle in candles) {
        [candle stroke];
    }
}

@end
