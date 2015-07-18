//
//  ChartSourceChunk.h
//  FX Simulator
//
//  Created by yuu on 2015/07/17.
//
//

#import <Foundation/Foundation.h>

@class ChartSource;
@class CurrencyPair;
@class MarketTimeScale;

@interface ChartSourceChunk : NSObject
- (instancetype)initWithDefaultAndMainChartCurrencyPair:(CurrencyPair *)currencyPair mainChartTimeScale:(MarketTimeScale *)timeScale;
+ (ChartSourceChunk *)createFromChartSourceDictionaryArray:(NSArray *)dictionaryArray;
- (ChartSource *)sourceOfChartIndex:(NSUInteger)index;
- (NSDictionary *)toDictionaryForSave;
@end
