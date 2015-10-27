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
@class Coordinate;
@class CoordinateRange;
@class ForexDataChunk;
@class ForexHistoryData;
@class VisibleChart;

@interface Candle : Indicator

@property (nonatomic) UIColor *downColor;
@property (nonatomic) UIColor *downLineColor;
@property (nonatomic) UIColor *upColor;
@property (nonatomic) UIColor *upLineColor;
@property (nonatomic, readonly) Coordinate *leftEndForexDataX;
@property (nonatomic, readonly) Coordinate *rightEndForexDataX;

/**
 DBには保存されない。
*/
+ (instancetype)createTemporaryDefaultCandle;

- (ForexDataChunk *)chunkRangeStartX:(float)startX endX:(float)endX;

- (ForexHistoryData *)forexDataOfPoint:(CGPoint)point;

- (ForexHistoryData *)leftEndForexData;

- (ForexHistoryData *)rightEndForexData;

- (CoordinateRange *)chartAreaOfForexData:(ForexHistoryData *)forexData;

- (ForexHistoryData *)forexDataFromLeftEnd:(NSUInteger)index;

@end
