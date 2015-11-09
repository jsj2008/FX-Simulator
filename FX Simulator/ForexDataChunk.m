//
//  ForexDataArray.m
//  FX Simulator
//
//  Created by yuu on 2015/07/04.
//
//

#import "ForexDataChunk.h"

#import "ForexHistoryData.h"
#import "ForexHistory.h"
#import "ForexHistoryFactory.h"
#import "Time.h"
#import "TimeFrame.h"
#import "Rate.h"

@implementation ForexDataChunk {
    NSArray *_sortedForexDataArray;
}

- (instancetype)initWithSortedForexDataArray:(NSArray *)array
{
    if (array.count == 0) {
        return nil;
    }
    
    if (self = [super init]) {
        _sortedForexDataArray = array;
    }
    
    return self;
}

- (instancetype)initWithForexDataArray:(NSArray *)array
{
    // closeが新しい順に並び変える。
    NSArray *sortedArray = [[[array sortedArrayUsingSelector:@selector(compareTime:)] reverseObjectEnumerator] allObjects];

    return [self initWithSortedForexDataArray:sortedArray];
}

- (void)enumerateForexDataUsingBlock:(void (^)(ForexHistoryData *, NSUInteger))block limit:(NSUInteger)limit
{
    if (limit == 0) {
        return;
    }
    
    NSRange range = NSMakeRange(0, limit);
    
    if ([self isOverRange:range forArray:_sortedForexDataArray]) {
        range = NSMakeRange(0, _sortedForexDataArray.count);
    }
    
    [self enumerateForexDataUsingBlock:^(ForexHistoryData *obj, NSUInteger idx) {
        block(obj, idx);
    } range:range resultReverse:NO];
}

/**
 Rangeが配列より大きいときは、実行されない。
*/
- (void)enumerateForexDataUsingBlock:(void (^)(ForexHistoryData *, NSUInteger))block range:(NSRange)range resultReverse:(BOOL)reverse
{
    if ([self isOverRange:range forArray:_sortedForexDataArray]) {
        return;
    }
    
    NSArray *rangeArray = [_sortedForexDataArray subarrayWithRange:range];
    
    NSEnumerationOptions option = 0;
    
    if (reverse) {
        option = NSEnumerationReverse;
    }
    
    [rangeArray enumerateObjectsWithOptions:option usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        block(obj, idx);
    }];
}

- (BOOL)isOverRange:(NSRange)range forArray:(NSArray *)array
{
    NSUInteger rangeLastIndex = range.location + range.length - 1;
    NSUInteger arrayLastIndex = array.count - 1;
    
    if (arrayLastIndex < rangeLastIndex) {
        return YES;
    } else {
        return NO;
    }
}

- (void)enumerateForexDataAndAverageRatesUsingBlock:(void (^)(ForexHistoryData *, NSUInteger, Rate *))block averageTerm:(NSUInteger)term limit:(NSUInteger)limit
{
    [self enumerateForexDataAndAverageOHLCRatesUsingBlock:^(ForexHistoryData *obj, NSUInteger idx, Rate *averageOpen, Rate *averageHigh, Rate *averageLow, Rate *averageClose) {
        block(obj, idx, averageClose);
    } averageTerm:term limit:limit resultReverse:NO open:NO high:NO low:NO close:YES];
}

- (void)enumerateForexDataAndAverageOHLCRatesUsingBlock:(void (^)(ForexHistoryData *, NSUInteger, Rate *, Rate *, Rate *, Rate *))block averageTerm:(NSUInteger)term limit:(NSUInteger)limit
{
    [self enumerateForexDataAndAverageOHLCRatesUsingBlock:^(ForexHistoryData *obj, NSUInteger idx, Rate *averageOpen, Rate *averageHigh, Rate *averageLow, Rate *averageClose) {
        
        block(obj, idx, averageOpen, averageHigh, averageLow, averageClose);
        
    } averageTerm:term limit:limit resultReverse:NO open:YES high:YES low:YES close:YES];
}

- (void)enumerateForexDataAndAverageOHLCRatesUsingBlock:(void (^)(ForexHistoryData *obj, NSUInteger idx, Rate *averageOpen, Rate *averageHigh, Rate *averageLow, Rate *averageClose))block averageTerm:(NSUInteger)term limit:(NSUInteger)limit resultReverse:(BOOL)reverse open:(BOOL)open high:(BOOL)high low:(BOOL)low close:(BOOL)close
{
    if (!(0 < term)) {
        return;
    }
    
    NSString *forexDataString = @"ForexData";
    NSString *averageOpenString = @"AverageOpen";
    NSString *averageHighString = @"AverageHigh";
    NSString *averageLowString = @"AverageLow";
    NSString *averageCloseString = @"AverageClose";
    
    NSMutableArray *array = [NSMutableArray array];
    
    [_sortedForexDataArray enumerateObjectsUsingBlock:^(ForexHistoryData *obj, NSUInteger idx, BOOL *stop) {
        
        if (limit < (idx + 1)) {
            *stop = YES;
        }
        
        NSRange range = NSMakeRange(idx, term);
        
        if ([self isOverRange:range forArray:_sortedForexDataArray]) {
            *stop = YES;
        }
        
        Rate *averageOpen = [Rate new];
        Rate *averageHigh = [Rate new];
        Rate *averageLow = [Rate new];
        Rate *averageClose = [Rate new];
        
        if (open) {
            averageOpen = [self getAverageRate:Open range:range];
        }
        
        if (high) {
            averageHigh = [self getAverageRate:High range:range];
        }
        
        if (low) {
            averageLow = [self getAverageRate:Low range:range];
        }
        
        if (close) {
            averageClose = [self getAverageRate:Close range:range];
        }
        
        NSDictionary *dic = @{forexDataString:obj, averageOpenString:averageOpen, averageHighString:averageHigh, averageLowString:averageLow, averageCloseString:averageClose};
        [array addObject:dic];
    }];
    
    NSEnumerationOptions option = 0;
    
    if (reverse) {
        option = NSEnumerationReverse;
    }
    
    [array enumerateObjectsWithOptions:option usingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        
        ForexHistoryData *data = obj[forexDataString];
        Rate *averageOpen = obj[averageOpenString];
        Rate *averageHigh = obj[averageHighString];
        Rate *averageLow = obj[averageLowString];
        Rate *averageClose = obj[averageCloseString];
        
        if (!open) {
            averageOpen = nil;
        }
        
        if (!high) {
            averageHigh = nil;
        }
        
        if (!low) {
            averageLow = nil;
        }
        
        if (!close) {
            averageClose = nil;
        }
        
        block(data, idx, averageOpen, averageHigh, averageLow, averageClose);
    }];
}

- (Rate *)getAverageRate:(RateType)type range:(NSRange)range
{
    return [[self getTotalRate:type range:range] divide:range.length];
}

- (Rate *)getTotalRate:(RateType)type range:(NSRange)range
{
    __block Rate *total = nil;
    
    [self enumerateForexDataUsingBlock:^(ForexHistoryData *obj, NSUInteger idx) {
        
        if (idx == 0) {
            total = [obj getRateForType:type];
        } else {
            total = [total addRate:[obj getRateForType:type]];
        }
        
    }  range:range resultReverse:NO];
    
    return total;
}

- (ForexDataChunk *)getForexDataChunkInRange:(NSRange)range
{
    NSUInteger lastIndex = range.location + range.length - 1;
    
    if (self.count < lastIndex + 1) {
        return nil;
    }
    
    return [[ForexDataChunk alloc] initWithForexDataArray:[_sortedForexDataArray subarrayWithRange:range]];
}

- (Rate *)getMinRate
{
    return [self getMinRateLimit:self.count];
}

- (Rate *)getMaxRate
{
    return [self getMaxRateLimit:self.count];
}

- (Rate *)getMinRateLimit:(NSUInteger)limit
{
    __block Rate *minRate = nil;
    
    [self enumerateForexDataUsingBlock:^(ForexHistoryData *obj, NSUInteger idx) {
        if (idx == 0) {
            minRate = obj.low;
        } else if (obj.low.rateValue < minRate.rateValue) {
            minRate = obj.low;
        }
    } limit:limit];
    
    return minRate;
}

- (Rate *)getMaxRateLimit:(NSUInteger)limit
{
    __block Rate *maxRate = nil;
    
    [self enumerateForexDataUsingBlock:^(ForexHistoryData *obj, NSUInteger idx) {
        if (idx == 0) {
            maxRate = obj.high;
        } else if (maxRate.rateValue < obj.high.rateValue) {
            maxRate = obj.high;
        }
    } limit:limit];
    
    return maxRate;
}

- (ForexDataChunk *)getChunkFromBaseTime:(Time *)time relativePosition:(NSInteger)pos limit:(NSUInteger)limit
{
    Time *newestDataTime = ((ForexHistoryData *)_sortedForexDataArray.firstObject).close.timestamp;
    Time *oldestDataTime = ((ForexHistoryData *)_sortedForexDataArray.lastObject).close.timestamp;
    
    NSComparisonResult result1 = [time compare:newestDataTime];
    NSComparisonResult result2 = [time compare:oldestDataTime];
    
    if (result1 == NSOrderedDescending || result2 == NSOrderedAscending) {
        return nil;
    }
    
    __block NSUInteger baseIndex = NSNotFound;
    
    [_sortedForexDataArray enumerateObjectsUsingBlock:^(ForexHistoryData *obj, NSUInteger idx, BOOL *stop) {
        NSComparisonResult result = [time compare:obj.close.timestamp];
        if (result == NSOrderedSame) {
            baseIndex = idx;
            *stop = YES;
        } else if (result == NSOrderedDescending) {
            if (0 < idx) {
                baseIndex = idx;
                *stop = YES;
            }
        }
        /*if ([time isEqualTime:obj.close.timestamp]) {
            baseIndex = idx;
            *stop = YES;
        }*/
    }];
    
    if (baseIndex == NSNotFound) {
        return nil;
    }
    
    NSInteger startIndex = baseIndex + (-pos);
    
    if (self.count-1 < startIndex) {
        return nil;
    }
    
    if (startIndex < 0) {
        startIndex = 0;
    }
    
    NSUInteger len = limit;
    
    if (self.count < (startIndex + len)) {
        len = self.count - startIndex;
    }
    
    return [self getForexDataChunkInRange:NSMakeRange(startIndex, len)];
}

- (void)addCurrentData:(ForexHistoryData *)data
{
    if (data == nil) {
        return;
    }
    
    NSMutableArray *array = [_sortedForexDataArray mutableCopy];
    
    [array insertObject:data atIndex:0];
    
    _sortedForexDataArray = [array copy];
}

- (ForexHistoryData *)getForexDataFromCurrent:(NSUInteger)back
{
    if (self.lastIndex < back) {
        return nil;
    }
    
    return _sortedForexDataArray[back];
}

- (ForexDataChunk *)chunkLimit:(NSUInteger)limit
{
    NSMutableArray *forexDataArray = [NSMutableArray array];
    
    [self enumerateForexDataUsingBlock:^(ForexHistoryData *obj, NSUInteger idx) {
        [forexDataArray addObject:obj];
    } limit:limit];
    
    return [[[self class] alloc] initWithForexDataArray:forexDataArray];
}

- (BOOL)existForexData:(ForexHistoryData *)forexData
{
    __block BOOL exist;
    
    [_sortedForexDataArray enumerateObjectsUsingBlock:^(ForexHistoryData *obj, NSUInteger idx, BOOL *stop) {
        if ([forexData isEqualToForexData:obj]) {
            exist = YES;
        }
    }];
    
    return exist;
}

- (ForexHistoryData *)getForexDataFromTouchPoint:(CGPoint)point displayCount:(NSUInteger)count viewSize:(CGSize)size
{
    float displayForexDataWidth = size.width / count;
    
    NSUInteger touchIndex = (size.width - point.x) / displayForexDataWidth;
    
    if (self.lastIndex < touchIndex) {
        return nil;
    }
    
    return _sortedForexDataArray[touchIndex];
}

- (void)complementedByTimeFrame:(TimeFrame *)timeFrame currentTime:(Time *)currentTime
{
    CurrencyPair *chunkCurrencyPair = [self current].currencyPair;
    TimeFrame *chunkTimeFrame = [self current].timeScale;
    
    NSComparisonResult resultTimeFrame = [timeFrame compareTimeFrame:chunkTimeFrame];
    
    if (resultTimeFrame != NSOrderedAscending) {
        return;
    }
    
    TimeFrame *minTimeFrame = timeFrame;
    Time *oldTime = [self currentTime];
    
    NSComparisonResult result = [currentTime compare:oldTime];
    
    if (!(result == NSOrderedDescending)) {
        return;
    }
    
    ForexHistory *forexHistory = [ForexHistoryFactory createForexHistoryFromCurrencyPair:chunkCurrencyPair timeScale:minTimeFrame];
    
    ForexDataChunk *chunk = [forexHistory selectMaxCloseTime:currentTime newerThan:oldTime];
    
    ForexHistoryData *newCurrentData = [[ForexHistoryData alloc] initWithForexDataChunk:chunk timeScale:chunkTimeFrame];
    
    [self unshift:newCurrentData];
    [self pop];
}

- (void)unshift:(ForexHistoryData *)forexData
{
    if (forexData == nil) {
        return;
    }
    
    NSMutableArray *array = [_sortedForexDataArray mutableCopy];
    
    [array insertObject:forexData atIndex:0];
    
    _sortedForexDataArray = [array copy];
}

- (void)pop
{
    NSUInteger lastIndex = _sortedForexDataArray.count - 1;
    
    NSMutableArray *array = [_sortedForexDataArray mutableCopy];
    
    [array removeObjectAtIndex:lastIndex];
    
    _sortedForexDataArray = [array copy];
}

- (void)maxTime:(Time *)time
{
    NSMutableIndexSet *indexes = [NSMutableIndexSet new];
    
    [_sortedForexDataArray enumerateObjectsUsingBlock:^(ForexHistoryData *obj, NSUInteger idx, BOOL *stop) {
        NSComparisonResult result = [time compare:obj.close.timestamp];
        if (result == NSOrderedAscending) {
            [indexes addIndex:idx];
        }
    }];
    
    NSMutableArray *array = [_sortedForexDataArray mutableCopy];
    
    [array removeObjectsAtIndexes:indexes];
    
    _sortedForexDataArray = array;
}

- (NSUInteger)count
{
    return _sortedForexDataArray.count;
}

- (NSUInteger)lastIndex
{
    return self.count - 1;
}

- (ForexHistoryData *)current
{
    return _sortedForexDataArray.firstObject;
}

- (Time *)currentTime
{
    return ((ForexHistoryData *)_sortedForexDataArray.firstObject).close.timestamp;
}

- ( ForexHistoryData *)oldest
{
    return _sortedForexDataArray.lastObject;
}

- (Time *)latestTime
{
    return self.current.latestTime;
}

- (Time *)oldestTime
{
    return self.oldest.oldestTime;
}

@end
