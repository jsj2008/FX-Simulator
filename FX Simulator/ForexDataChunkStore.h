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
@class MarketTimeScale;
        
@interface ForexDataChunkStore : NSObject
- (instancetype)initWithCurrencyPair:(CurrencyPair *)currencyPair timeScale:(MarketTimeScale *)timeScale;
- (ForexDataChunk *)getChunkFromHeadData:(ForexHistoryData *)data limit:(NSUInteger)limit;
- (ForexDataChunk *)getChunkFromHeadData:(ForexHistoryData *)data back:(NSUInteger)back limit:(NSUInteger)limit;
- (ForexDataChunk *)getChunkFromNextDataOf:(ForexHistoryData *)data limit:(NSUInteger)limit;
@end
