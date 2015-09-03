//
//  ForexDataArray.m
//  FX Simulator
//
//  Created by yuu on 2015/07/04.
//
//

#import "ForexDataChunk.h"

#import "ForexHistoryData.h"
#import "MarketTime.h"
#import "Rate.h"

@implementation ForexDataChunk {
    NSArray *_forexDataArray;
}

- (instancetype)initWithForexDataArray:(NSArray *)array
{
    if (array.count == 0) {
        return nil;
    }
    
    if (self = [super init]) {
        // closeが新しい順に並び変える。
        _forexDataArray = [[[array sortedArrayUsingSelector:@selector(compareTime:)] reverseObjectEnumerator] allObjects];
    }

    return self;
}

- (void)enumerateForexDataUsingBlock:(void (^)(ForexHistoryData *, NSUInteger))block limit:(NSUInteger)limit
{
    if (limit == 0) {
        return;
    }
    
    NSRange range = NSMakeRange(0, limit);
    
    if ([self isOverRange:range forArray:_forexDataArray]) {
        range = NSMakeRange(0, _forexDataArray.count);
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
    if ([self isOverRange:range forArray:_forexDataArray]) {
        return;
    }
    
    NSArray *rangeArray = [_forexDataArray subarrayWithRange:range];
    
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
    
    [_forexDataArray enumerateObjectsUsingBlock:^(ForexHistoryData *obj, NSUInteger idx, BOOL *stop) {
        
        if (limit < (idx + 1)) {
            *stop = YES;
        }
        
        NSRange range = NSMakeRange(idx, term);
        
        if ([self isOverRange:range forArray:_forexDataArray]) {
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
    
    return [[ForexDataChunk alloc] initWithForexDataArray:[_forexDataArray subarrayWithRange:range]];
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

- (ForexDataChunk *)getChunkFromBaseTime:(MarketTime *)time relativePosition:(NSInteger)pos limit:(NSUInteger)limit
{
    MarketTime *newestDataTime = ((ForexHistoryData *)_forexDataArray.firstObject).close.timestamp;
    MarketTime *oldestDataTime = ((ForexHistoryData *)_forexDataArray.lastObject).close.timestamp;
    
    NSComparisonResult result1 = [time compare:newestDataTime];
    NSComparisonResult result2 = [time compare:oldestDataTime];
    
    if (result1 == NSOrderedDescending || result2 == NSOrderedAscending) {
        return nil;
    }
    
    __block NSUInteger baseIndex = NSNotFound;
    
    [_forexDataArray enumerateObjectsUsingBlock:^(ForexHistoryData *obj, NSUInteger idx, BOOL *stop) {
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
    
    NSMutableArray *array = [_forexDataArray mutableCopy];
    
    [array insertObject:data atIndex:0];
    
    _forexDataArray = [array copy];
}

- (ForexHistoryData *)getForexDataFromCurrent:(NSUInteger)back
{
    if (self.lastIndex < back) {
        return nil;
    }
    
    return _forexDataArray[back];
}

- (ForexHistoryData *)getForexDataFromTouchPoint:(CGPoint)point displayCount:(NSUInteger)count viewSize:(CGSize)size
{
    float displayForexDataWidth = size.width / count;
    
    NSUInteger touchIndex = (size.width - point.x) / displayForexDataWidth;
    
    if (self.lastIndex < touchIndex) {
        return nil;
    }
    
    return _forexDataArray[touchIndex];
}

- (NSUInteger)count
{
    return _forexDataArray.count;
}

- (NSUInteger)lastIndex
{
    return self.count - 1;
}

- (ForexHistoryData *)current
{
    return _forexDataArray.firstObject;
}

- ( ForexHistoryData *)oldest
{
    return _forexDataArray.lastObject;
}

@end
