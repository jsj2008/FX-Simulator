//
//  ChartSource.h
//  FX Simulator
//
//  Created by yuu on 2015/07/16.
//
//

#import <Foundation/Foundation.h>

@class CurrencyPair;
@class IndicatorChunk;
@class MarketTimeScale;

@interface ChartSource : NSObject
- (instancetype)initWithDefaultAndChartIndex:(NSUInteger)index currencyPair:(CurrencyPair *)currencyPair timeScale:(MarketTimeScale *)timeScale isMainChart:(BOOL)isMainChart isSubChart:(BOOL)isSubChart;
- (instancetype)initWithDictionary:(NSDictionary *)dic;
- (BOOL)validateChartSource;
@property (nonatomic) NSUInteger displayForexDataCount;
@property (nonatomic, readonly) NSUInteger chartIndex;
@property (nonatomic, readonly) CurrencyPair *currencyPair;
@property (nonatomic, readonly) MarketTimeScale *timeScale;
@property (nonatomic, readonly) BOOL isMainChart;
@property (nonatomic, readonly) BOOL isSubChart;
@property (nonatomic, readonly) IndicatorChunk *displayIndicatorChunk;
@property (nonatomic, readonly) NSDictionary *sourceDictionary;
@end
