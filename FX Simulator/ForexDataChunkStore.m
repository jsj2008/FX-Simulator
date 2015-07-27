//
//  ForexDataChunkStore.m
//  FX Simulator
//
//  Created by yuu on 2015/07/07.
//
//

#import "ForexDataChunkStore.h"

#import "CurrencyPair.h"
#import "ForexDataChunk.h"
#import "ForexHistory.h"
#import "ForexHistoryData.h"
#import "ForexHistoryFactory.h"
#import "TimeFrame.h"
#import "Rate.h"

@implementation ForexDataChunkStore {
    CurrencyPair *_currencyPair;
    TimeFrame *_timeScale;
    ForexDataChunk *_forexDataChunkCache;
    ForexHistory *_forexHistory;
    NSUInteger _frontLimit;
    NSUInteger _backLimit;
}

static const NSUInteger buffer = 200;

- (instancetype)initWithCurrencyPair:(CurrencyPair *)currencyPair timeScale:(TimeFrame *)timeScale getMaxLimit:(NSUInteger)maxLimit
{
    if (currencyPair == nil || timeScale == nil) {
        return nil;
    }
    
    if (self = [super init]) {
        _currencyPair = currencyPair;
        _timeScale = timeScale;
        _forexHistory = [ForexHistoryFactory createForexHistoryFromCurrencyPair:_currencyPair timeScale:_timeScale];
        if (_forexHistory == nil) {
            return nil;
        }
        _frontLimit = buffer / 2;
        _backLimit = maxLimit + _frontLimit;
    }
    
    return self;
}

// relativePositionは、relativePositionからLimitまでの範囲が、キャッシュの範囲を超えないような、数値にする。数値が、大きすぎると、nilになる。つまり、baseDataとrelativePositionが離れすぎると、nilになる。
- (ForexDataChunk *)getChunkFromBaseData:(ForexHistoryData *)data relativePosition:(NSInteger)pos limit:(NSUInteger)limit
{
    if (data == nil || ![_currencyPair isEqualCurrencyPair:data.currencyPair]) {
        return nil;
    }
    
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
    NSComparisonResult result = [_timeScale compare:data.timeScale];
    
    // dataの時間軸の方が、短いとき。
    if (result == NSOrderedDescending) {
        ForexHistoryData *equalTimeData = [_forexHistory selectCloseTime:data.close.timestamp];
        
        if (equalTimeData == nil) {
            // 短い時間軸のdataに、dataより古くて、一番近いこのStoreの時間軸(_timeScale)のデータを取得する。
            ForexHistoryData *oldData = [_forexHistory selectMaxCloseTime:data.close.timestamp limit:1].firstObject;
            ForexHistoryData *newTimeScaleData = [self toTimeScaleDataFromCurrentData:data newestThan:oldData.close.timestamp];
            ForexDataChunk *chunk = [self getChunkFromBaseData:oldData relativePosition:0 limit:limit];
            [chunk addCurrentData:newTimeScaleData];
            
            return chunk;
        } else {
            return [self getChunkFromBaseData:equalTimeData relativePosition:0 limit:limit];
        }
        
    } else if (result == NSOrderedAscending) {
        
        ForexHistoryData *equalTimeData = [_forexHistory selectCloseTime:data.close.timestamp];
        return [self getChunkFromBaseData:equalTimeData relativePosition:0 limit:limit];
    
    } else {
        
        return [self getChunkFromBaseData:data relativePosition:0 limit:limit];
        
    }
}

- (ForexDataChunk *)getChunkFromNextDataOf:(ForexHistoryData *)data limit:(NSUInteger)limit
{
    if (![_timeScale isEqualToTimeFrame:data.timeScale]) {
        return nil;
    }
    
    return [self getChunkFromBaseData:data relativePosition:1 limit:limit];
}

/**
 currentDataを先頭のデータとして、currentDataの時間軸で、oldTimeより新しいデータを取得し、それで一つの新しいForexData（実際のデータベース上にはない、このStoreと同じ時間軸のデータ）を作成する。
*/
- (ForexHistoryData *)toTimeScaleDataFromCurrentData:(ForexHistoryData *)currentData newestThan:(MarketTime *)oldTime;
{
    ForexHistory *forexHistory = [ForexHistoryFactory createForexHistoryFromCurrencyPair:_currencyPair timeScale:currentData.timeScale];
    
    ForexDataChunk *chunk = [forexHistory selectMaxCloseTime:currentData.close.timestamp newerThan:oldTime];
    
    return [[ForexHistoryData alloc] initWithForexDataChunk:chunk timeScale:_timeScale];
}

@end
