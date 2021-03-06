//
//  Market.h
//  FX Simulator
//
//  Created  on 2014/11/13.
//  
//

#import <Foundation/Foundation.h>

@class CurrencyPair;
@class ForexDataChunk;
@class ForexHistoryData;
@class Spread;
@class Time;
@class TimeFrame;
@class Rates;

@interface Market : NSObject

@property (nonatomic, readonly) Time *currentTime;

- (instancetype)initWithCurrencyPair:(CurrencyPair *)currencyPair timeFrame:(TimeFrame *)timeFrame lastLoadedTime:(Time *)time spread:(Spread *)spread;

- (void)add;

/**
 最新のRatesを取得。
 */
- (Rates *)currentRatesOfCurrencyPair:(CurrencyPair *)currencyPair;

- (ForexDataChunk *)chunkForCurrencyPair:(CurrencyPair *)currencyPair timeFrame:(TimeFrame *)timeFrame Limit:(NSUInteger)limit;

- (ForexDataChunk *)chunkForCenterForexData:(ForexHistoryData *)forexData frontLimit:(NSUInteger)frontLimit backLimit:(NSUInteger)backLimit;

- (BOOL)didLoadLastData;

@end
