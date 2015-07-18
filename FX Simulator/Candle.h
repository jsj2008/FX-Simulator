//
//  CandleChart.h
//  FX Simulator
//
//  Created by yuu on 2015/07/05.
//
//

#import <Foundation/Foundation.h>
#import "Indicator.h"

@class CandleSource;

@interface Candle : Indicator
- (instancetype)initWithCandleSource:(CandleSource *)source;
- (void)strokeIndicatorFromForexDataChunk:(ForexDataChunk *)chunk displayForexDataCount:(NSInteger)count displaySize:(CGSize)size;
@end
