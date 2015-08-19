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
@property (nonatomic) UIColor *downColor;
@property (nonatomic) UIColor *downLineColor;
@property (nonatomic) UIColor *upColor;
@property (nonatomic) UIColor *upLineColor;

/**
 DBには保存されない。
*/
+ (instancetype)createDefaultCandle;

- (instancetype)initWithCandleSource:(CandleSource *)source;
- (void)strokeIndicatorFromForexDataChunk:(ForexDataChunk *)chunk displayForexDataCount:(NSInteger)count displaySize:(CGSize)size;
@end
