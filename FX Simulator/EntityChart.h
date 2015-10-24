//
//  EntityChart.h
//  FXSimulator
//
//  Created by yuu on 2015/10/08.
//
//

#import <Foundation/Foundation.h>

@import UIKit;

@class Coordinate;
@class CurrencyPair;
@class ForexHistoryData;
@class ForexDataChunk;
@class IndicatorChunk;
@class Market;
@class Rate;
@class TimeFrame;

@interface EntityChart : NSObject
@property (nonatomic, readonly) UIImage *chartImage;
@property (nonatomic, readonly) Rate *maxRate;
@property (nonatomic, readonly) Rate *minRate;
@property (nonatomic, readonly) EntityChart *previousEntityChart;
@property (nonatomic, readonly) EntityChart *nextEntityChart;
@property (nonatomic, readonly) Coordinate *visibleViewDefaultStartX;
@property (nonatomic, readonly) Coordinate *visibleViewDefaultEndX;

+ (UIImageView *)entityChartView;

+ (NSUInteger)forexDataCount;

- (instancetype)initWithCurrencyPair:(CurrencyPair *)currencyPair timeFrame:(TimeFrame *)timeFrame indicatorChunk:(IndicatorChunk *)indicatorChunk;

- (void)strokeForMarket:(Market *)market;

- (ForexDataChunk *)chunkForRangeStartX:(float)startX endX:(float)endX;

- (ForexHistoryData *)leftEndForexData;

- (void)preparePreviousEntityChartForMarket:(Market *)market;

- (void)prepareNextEntityChartForMarket:(Market *)market;

@end
