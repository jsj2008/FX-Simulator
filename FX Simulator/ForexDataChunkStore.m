//
//  ForexDataChunkStore.m
//  FX Simulator
//
//  Created by yuu on 2015/07/07.
//
//

#import "ForexDataChunkStore.h"

#import "ForexDataChunk.h"
#import "ForexHistory.h"
#import "ForexHistoryFactory.h"

@implementation ForexDataChunkStore {
    ForexDataChunk *_forexDataChunkCache;
    ForexHistory *_forexHistory;
    NSUInteger _cacheSize;
    NSUInteger _sideLimit;
}

- (instancetype)initWithCurrencyPair:(CurrencyPair *)currencyPair timeScale:(MarketTimeScale *)timeScale
{
    if (currencyPair == nil || timeScale == nil) {
        return nil;
    }
    
    if (self = [super init]) {
        _forexHistory = [ForexHistoryFactory createForexHistoryFromCurrencyPair:currencyPair timeScale:timeScale];
        if (_forexHistory == nil) {
            return nil;
        }
        _cacheSize = 1001;
        _sideLimit = (_cacheSize - 1) / 2;
    }
    
    return self;
}

- (ForexDataChunk *)getChunkFromBaseData:(ForexHistoryData *)data relativePosition:(NSInteger)pos limit:(NSUInteger)limit
{
    if (_forexDataChunkCache == nil) {
        _forexDataChunkCache = [_forexHistory selectCenterData:data sideLimit:_sideLimit];
    }

    ForexDataChunk *chunk = [_forexDataChunkCache getChunkFromBaseData:data relativePosition:pos limit:limit];
    
    if (chunk == nil || chunk.count < limit) {
        _forexDataChunkCache = [_forexHistory selectCenterData:data sideLimit:_sideLimit];
        chunk = [_forexDataChunkCache getChunkFromBaseData:data relativePosition:pos limit:limit];
    }
    
    return chunk;
}

- (ForexDataChunk *)getChunkFromHeadData:(ForexHistoryData *)data limit:(NSUInteger)limit
{
    return [self getChunkFromBaseData:data relativePosition:0 limit:limit];
}

- (ForexDataChunk *)getChunkFromHeadData:(ForexHistoryData *)data back:(NSUInteger)back limit:(NSUInteger)limit
{
    return nil;
}

- (ForexDataChunk *)getChunkFromNextDataOf:(ForexHistoryData *)data limit:(NSUInteger)limit
{
    return [self getChunkFromBaseData:data relativePosition:1 limit:limit];
}

@end
