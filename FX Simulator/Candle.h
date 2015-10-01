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
@class ForexDataChunk;
@class ForexHistoryData;
@class VisibleChart;

@interface Candle : Indicator

@property (nonatomic) UIColor *downColor;
@property (nonatomic) UIColor *downLineColor;
@property (nonatomic) UIColor *upColor;
@property (nonatomic) UIColor *upLineColor;

/**
 DBには保存されない。
*/
+ (instancetype)createTemporaryDefaultCandle;

- (ForexDataChunk *)chunkRangeStartX:(float)startX endX:(float)endX;

- (ForexHistoryData *)leftEndForexData;

- (float)zoneStartXOfForexData:(ForexHistoryData *)forexData;

- (float)zoneEndXOfForexData:(ForexHistoryData *)forexData;

@end
