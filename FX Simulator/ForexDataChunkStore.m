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
    NSUInteger _frontLimit;
    NSUInteger _backLimit;
}

static const NSUInteger buffer = 200;

- (instancetype)initWithCurrencyPair:(CurrencyPair *)currencyPair timeScale:(MarketTimeScale *)timeScale getMaxLimit:(NSUInteger)maxLimit
{
    if (currencyPair == nil || timeScale == nil) {
        return nil;
    }
    
    if (self = [super init]) {
        _forexHistory = [ForexHistoryFactory createForexHistoryFromCurrencyPair:currencyPair timeScale:timeScale];
        if (_forexHistory == nil) {
            return nil;
        }
        _frontLimit = buffer / 2;
        _backLimit = maxLimit + _frontLimit;
    }
    
    return self;
}

- (ForexDataChunk *)getChunkFromBaseData:(ForexHistoryData *)data relativePosition:(NSInteger)pos limit:(NSUInteger)limit
{
    if (_forexDataChunkCache == nil) {
        _forexDataChunkCache = [_forexHistory selectBaseData:data frontLimit:_frontLimit backLimit:_backLimit];
    }

    ForexDataChunk *chunk = [_forexDataChunkCache getChunkFromBaseData:data relativePosition:pos limit:limit];
    
    if (chunk == nil || chunk.count < limit) {
        _forexDataChunkCache = [_forexHistory selectBaseData:data frontLimit:_frontLimit backLimit:_backLimit];
        chunk = [_forexDataChunkCache getChunkFromBaseData:data relativePosition:pos limit:limit];
    }
    
    return chunk;
}

- (ForexDataChunk *)getChunkFromBaseData:(ForexHistoryData *)data limit:(NSUInteger)limit
{
    return [self getChunkFromBaseData:data relativePosition:0 limit:limit];
}

- (ForexDataChunk *)getChunkFromBaseData:(ForexHistoryData *)data back:(NSUInteger)back limit:(NSUInteger)limit
{
    return nil;
}

- (ForexDataChunk *)getChunkFromNextDataOf:(ForexHistoryData *)data limit:(NSUInteger)limit
{
    return [self getChunkFromBaseData:data relativePosition:1 limit:limit];
}

@end
