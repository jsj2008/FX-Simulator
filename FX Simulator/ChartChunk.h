//
//  ChartChunk.h
//  FX Simulator
//
//  Created by yuu on 2015/07/18.
//
//

#import <Foundation/Foundation.h>


@class Chart;
@class CurrencyPair;
@class MarketTimeScale;

@interface ChartChunk : NSObject
- (instancetype)initWithChartArray:(NSArray *)chartArray;

/**
 メインチャートの通貨と時間軸をもとに、
 メインチャート1つと、サブチャート3つを生成する。
 時間軸が重複しないように生成する。
*/
- (instancetype)initWithDefaultAndMainChartCurrencyPair:(CurrencyPair *)currencyPair mainChartTimeScale:(MarketTimeScale *)timeScale;

/**
 ChartIndexがindexなチャート。
*/
- (Chart *)chartOfChartIndex:(NSUInteger)index;

+ (ChartChunk *)createFromChartSourceDictionaryArray:(NSArray *)dictionaryArray;
@property (nonatomic, readonly) NSArray *chartSourceDictionaryArray;
@end
