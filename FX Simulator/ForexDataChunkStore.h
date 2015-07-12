//
//  ForexDataChunkStore.h
//  FX Simulator
//
//  Created by yuu on 2015/07/07.
//
//

#import <Foundation/Foundation.h>

@class CurrencyPair;
@class ForexHistoryData;
@class ForexDataChunk;
@class MarketTime;
@class MarketTimeScale;

/**
 ForexDataChunkのキャッシュを持ち、それを管理する。
*/
@interface ForexDataChunkStore : NSObject

/**
 @param maxLimit メソッドで取得する最大のLimit。これをもとに、キャッシュのサイズが決まる。
*/
- (instancetype)initWithCurrencyPair:(CurrencyPair *)currencyPair timeScale:(MarketTimeScale *)timeScale getMaxLimit:(NSUInteger)maxLimit;

/**
 基準となるデータを先頭に、最大Limit個のデータを取得する。
*/
- (ForexDataChunk *)getChunkFromBaseData:(ForexHistoryData *)data limit:(NSUInteger)limit;

/**
 基準となるデータのback個前のデータを先頭に、最大Limit個のデータを取得する。
*/
//- (ForexDataChunk *)getChunkFromBaseData:(ForexHistoryData *)data back:(NSUInteger)back limit:(NSUInteger)limit;

/**
 基準となるデータの次のデータを先頭に、最大Limit個のデータを取得する。
*/
- (ForexDataChunk *)getChunkFromNextDataOf:(ForexHistoryData *)data limit:(NSUInteger)limit;

- (ForexHistoryData *)getChunkFromCloseTime:(MarketTime *)closeTime limit:(NSUInteger)limit;

- (ForexHistoryData *)getChunkFromCloseTime:(MarketTime *)closeTime back:(NSUInteger)back limit:(NSUInteger)limit;

@end
