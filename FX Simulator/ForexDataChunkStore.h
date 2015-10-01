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
@class Time;
@class TimeFrame;

/**
 ForexDataChunkのキャッシュを持ち、それを管理する。
*/
@interface ForexDataChunkStore : NSObject

/**
 @param maxLimit メソッドで取得する最大のLimit。これをもとに、キャッシュのサイズが決まる。
*/
- (instancetype)initWithCurrencyPair:(CurrencyPair *)currencyPair timeScale:(TimeFrame *)timeScale getMaxLimit:(NSUInteger)maxLimit;

- (ForexDataChunk *)getChunkFromBaseTime:(Time *)time limit:(NSUInteger)limit;

/**
 基準となるデータの次のデータを先頭に、最大Limit個のデータを取得する。
*/
- (ForexDataChunk *)getChunkFromNextDataOfTime:(Time *)time limit:(NSUInteger)limit;

- (ForexDataChunk *)chunkForBaseTime:(Time *)time frontLimit:(NSUInteger)frontLimit backLimit:(NSUInteger)backLimit;

@end
