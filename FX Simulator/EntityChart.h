//
//  EntityChart.h
//  FXSimulator
//
//  Created by yuu on 2015/10/08.
//
//

#import <Foundation/Foundation.h>

@import UIKit;

@class CurrencyPair;
@class ForexHistoryData;
@class ForexDataChunk;
@class IndicatorChunk;
@class Market;
@class Rate;
@class TimeFrame;

@interface EntityChart : NSObject

@property (nonatomic, readonly) UIImage *image;
@property (nonatomic, readonly) Rate *maxRate;
@property (nonatomic, readonly) Rate *minRate;
@property (nonatomic, readonly) EntityChart *previousEntityChart;
@property (nonatomic, readonly) EntityChart *nextEntityChart;
@property (nonatomic, readonly) float visibleViewDefaultStartX;
@property (nonatomic, readonly) float visibleViewDefaultEndX;

- (instancetype)initWithCurrencyPair:(CurrencyPair *)currencyPair timeFrame:(TimeFrame *)timeFrame indicatorChunk:(IndicatorChunk *)indicatorChunk viewSize:(CGSize)viewSize;

- (void)strokeForMarket:(Market *)market;

- (ForexDataChunk *)chunkForRangeStartX:(float)startX endX:(float)endX;

- (ForexHistoryData *)leftEndForexData;

- (float)zoneStartXOfForexData:(ForexHistoryData *)forexData;

- (float)zoneEndXOfForexData:(ForexHistoryData *)forexData;

- (float)zoneStartXOfForexDataFromLeftEnd:(NSUInteger)index;

- (ForexHistoryData *)forexDataFromLeftEnd:(NSUInteger)index;

- (void)preparePreviousEntityChartForMarket:(Market *)market;

- (void)prepareNextEntityChartForMarket:(Market *)market;

@end
