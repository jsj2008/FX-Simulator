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
#import "Time.h"
#import "TimeFrame.h"
#import "TimeFrameChunk.h"
#import "Rate.h"
#import "Setting.h"

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
- (ForexDataChunk *)getChunkFromBaseTime:(Time *)time relativePosition:(NSInteger)pos limit:(NSUInteger)limit
{
    if (_forexDataChunkCache == nil) {
        _forexDataChunkCache = [_forexHistory selectBaseTime:time frontLimit:_frontLimit backLimit:_backLimit];
    }
    
    ForexDataChunk *chunk = [_forexDataChunkCache getChunkFromBaseTime:time relativePosition:pos limit:limit];
    
    if (chunk == nil || chunk.count < limit) {
        _forexDataChunkCache = [_forexHistory selectBaseTime:time frontLimit:_frontLimit backLimit:_backLimit];
        chunk = [_forexDataChunkCache getChunkFromBaseTime:time relativePosition:pos limit:limit];
    }
    
    return chunk;
}

- (ForexDataChunk *)getChunkFromBaseTime:(Time *)time limit:(NSUInteger)limit
{
    ForexDataChunk *chunk = [self getChunkFromBaseTime:time relativePosition:0 limit:limit];
    
    return chunk;
    
    /*if (chunk == nil) {
        return nil;
    }
    
    NSComparisonResult result = [time compare:chunk.current.close.timestamp];
    
    if (result == NSOrderedSame) {
        return chunk;
    } else if (result == NSOrderedDescending) {
        ForexHistoryData *newTimeFrameData = [self getTimeFrameDataFromCurrentTime:time newestThan:chunk.current.close.timestamp];
        if (newTimeFrameData) {
            [chunk addCurrentData:newTimeFrameData];
        }
        return chunk;
    } else {
        return nil;
    }*/
    
}

- (ForexDataChunk *)getChunkFromNextDataOfTime:(Time *)time limit:(NSUInteger)limit
{
    return [self getChunkFromBaseTime:time relativePosition:1 limit:limit];
}

- (ForexDataChunk *)chunkForBaseTime:(Time *)time frontLimit:(NSUInteger)frontLimit backLimit:(NSUInteger)backLimit
{
    return [_forexHistory selectBaseTime:time frontLimit:frontLimit backLimit:backLimit];
}

/**
 currentTimeとoldTimeの間の時間足データを作成する。
 例えば1時間足のチャートを、15分足にしてみると、1時間で割り切れる時間以外は、15分足の端数がでる。その端数を1時間足に変換して、オリジナルの1時間足を作成する。
*/
- (ForexHistoryData *)getTimeFrameDataFromCurrentTime:(Time *)currentTime newestThan:(Time *)oldTime
{
    TimeFrame *minTimeFrame = [[Setting timeFrameList] minTimeFrame];
    
    ForexHistory *forexHistory = [ForexHistoryFactory createForexHistoryFromCurrencyPair:_currencyPair timeScale:minTimeFrame];
    
    ForexDataChunk *chunk = [forexHistory selectMaxCloseTime:currentTime newerThan:oldTime];
    
    return [[ForexHistoryData alloc] initWithForexDataChunk:chunk timeScale:_timeScale];
}

@end
