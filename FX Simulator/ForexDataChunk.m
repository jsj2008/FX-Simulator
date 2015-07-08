//
//  ForexDataArray.m
//  FX Simulator
//
//  Created by yuu on 2015/07/04.
//
//

#import "ForexDataChunk.h"

#import "ForexHistoryData.h"
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
        _forexDataArray = array;
        _current = _forexDataArray.firstObject;
    }

    return self;
}

- (void)enumerateObjectsUsingBlock:(void (^)(ForexHistoryData *, NSUInteger))block limit:(NSUInteger)limit resultReverse:(BOOL)revers
{
    if (limit == 0) {
        return;
    }
    
    NSRange range = NSMakeRange(0, limit);
    
    if ([self isOverRange:range forArray:_forexDataArray]) {
        range = NSMakeRange(0, _forexDataArray.count);
    }
    
    [self enumerateObjectsUsingBlock:^(ForexHistoryData *obj, NSUInteger idx) {
        block(obj, idx);
    } range:range resultReverse:revers];
}

/**
 Rangeが配列より大きいときは、実行されない。
*/
- (void)enumerateObjectsUsingBlock:(void (^)(ForexHistoryData *, NSUInteger))block range:(NSRange)range resultReverse:(BOOL)reverse
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

- (void)enumerateObjectsAndAverageRatesUsingBlock:(void (^)(ForexHistoryData *, NSUInteger, Rate *))block averageTerm:(NSUInteger)term limit:(NSUInteger)limit resultReverse:(BOOL)reverse
{
    [self enumerateObjectsAndAverageOHLCRatesUsingBlock:^(ForexHistoryData *obj, NSUInteger idx, Rate *averageOpen, Rate *averageHigh, Rate *averageLow, Rate *averageClose) {
        block(obj, idx, averageClose);
    } averageTerm:term limit:limit resultReverse:reverse open:NO high:NO low:NO close:YES];
    
    /*if (!(0 < term)) {
        return;
    }
    
    NSEnumerationOptions option = 0;
    
    if (reverse) {
        option = NSEnumerationReverse;
    }
    
    [_forexDataArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        if (limit < (idx + 1)) {
            *stop = YES;
        }
        
        NSRange range = NSMakeRange(idx, term);
        
        if (![self validateRange:range forArray:_forexDataArray]) {
            *stop = YES;
        }
        
        Rate *averageClose = [self getAverageRate:Close range:range];
        
        block(obj, idx, averageClose);
    }];*/
}

- (void)enumerateObjectsAndAverageOHLCRatesUsingBlock:(void (^)(ForexHistoryData *, NSUInteger, Rate *, Rate *, Rate *, Rate *))block averageTerm:(NSUInteger)term limit:(NSUInteger)limit resultReverse:(BOOL)reverse
{
    [self enumerateObjectsAndAverageOHLCRatesUsingBlock:^(ForexHistoryData *obj, NSUInteger idx, Rate *averageOpen, Rate *averageHigh, Rate *averageLow, Rate *averageClose) {
        
        block(obj, idx, averageOpen, averageHigh, averageLow, averageClose);
        
    } averageTerm:term limit:limit resultReverse:reverse open:YES high:YES low:YES close:YES];
    
    /*if (term == 0) {
        return;
    }
    
    [_forexDataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        NSRange range = NSMakeRange(idx, term);
        
        if (![self validateRange:range forArray:_forexDataArray]) {
            *stop = YES;
        }
        
        Rate *averageOpen = [self getAverageRate:Open range:range];
        Rate *averageHigh = [self getAverageRate:High range:range];
        Rate *averageLow = [self getAverageRate:Low range:range];
        Rate *averageClose = [self getAverageRate:Close range:range];
        
        block(obj, idx, averageOpen, averageHigh, averageLow, averageClose);
    }];*/
}

- (void)enumerateObjectsAndAverageOHLCRatesUsingBlock:(void (^)(ForexHistoryData *obj, NSUInteger idx, Rate *averageOpen, Rate *averageHigh, Rate *averageLow, Rate *averageClose))block averageTerm:(NSUInteger)term limit:(NSUInteger)limit resultReverse:(BOOL)reverse open:(BOOL)open high:(BOOL)high low:(BOOL)low close:(BOOL)close
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
    
    [self enumerateObjectsUsingBlock:^(ForexHistoryData *obj, NSUInteger idx) {
        
        if (idx == 0) {
            total = [obj getRateForType:type];
        } else {
            total = [total addRate:[obj getRateForType:type]];
        }
        
    }  range:range resultReverse:NO];
    
    return total;
}

/*- (ForexDataChunk *)getForexDataLimit:(NSUInteger)limit
{
    if ([self count] == 0 || limit == 0) {
        return nil;
    }
    
    if ([self count] < limit) {
        limit = [self count];
    }
    
    return [self getForexDataChunkInRange:NSMakeRange(0, limit)];
}*/

- (ForexDataChunk *)getForexDataChunkInRange:(NSRange)range
{
    NSUInteger lastIndex = range.location + range.length - 1;
    
    if (self.count < lastIndex + 1) {
        return nil;
    }
    
    return [[ForexDataChunk alloc] initWithForexDataArray:[_forexDataArray subarrayWithRange:range]];
}

- (Rate *)getMinRateLimit:(NSUInteger)limit
{
    //NSArray *limitArray = [self getArrayLimit:limit];
    
    /*NSPredicate *predicate = [NSPredicate predicateWithFormat:@"low.rateValue == %@.@min.low.rateValue", limitArray];
    NSArray *results = [limitArray filteredArrayUsingPredicate:predicate];
    
    return ((ForexHistoryData *)results[0]).low;*/
    
    /*NSArray *rangeArray = [self getArrayLimit:limit];
    
    return [[Rate alloc] initWithRateValue:[[rangeArray valueForKeyPath:@"@min.low.rateValue"] doubleValue] currencyPair:nil timestamp:nil];*/
    
    __block Rate *minRate = nil;
    
    [self enumerateObjectsUsingBlock:^(ForexHistoryData *obj, NSUInteger idx) {
        if (idx == 0) {
            minRate = obj.low;
        } else if (obj.low.rateValue < minRate.rateValue) {
            minRate = obj.low;
        }
    } limit:limit resultReverse:NO];
    
    return minRate;
}

- (Rate *)getMaxRateLimit:(NSUInteger)limit
{
    __block Rate *maxRate = nil;
    
    [self enumerateObjectsUsingBlock:^(ForexHistoryData *obj, NSUInteger idx) {
        if (idx == 0) {
            maxRate = obj.high;
        } else if (maxRate.rateValue < obj.high.rateValue) {
            maxRate = obj.high;
        }
    } limit:limit resultReverse:NO];
    
    return maxRate;
}

-(NSArray*)getArrayLimit:(NSUInteger)limit
{
    if (!(0 < limit)) {
        return nil;
    }
    
    NSRange range = NSMakeRange(0, limit);
    
    if ([self isOverRange:range forArray:_forexDataArray]) {
        range = NSMakeRange(0, _forexDataArray.count);
    }
    
    return [_forexDataArray subarrayWithRange:range];
}

- (ForexDataChunk *)getChunkFromBaseData:(ForexHistoryData *)data relativePosition:(NSInteger)pos limit:(NSUInteger)limit
{
    NSUInteger baseIndex = [_forexDataArray indexOfObject:data];
    
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

- (ForexDataChunk *)getChunkFromHeadData:(ForexHistoryData *)data limit:(NSUInteger)limit
{
    return [self getChunkFromBaseData:data relativePosition:0 limit:limit];
}

- (ForexDataChunk *)getChunkFromHeadData:(ForexHistoryData *)data back:(NSUInteger)back limit:(NSUInteger)limit
{
    return [self getChunkFromBaseData:data relativePosition:-back limit:limit];
}

- (ForexDataChunk *)getChunkFromNextDataOf:(ForexHistoryData *)data limit:(NSUInteger)limit
{
    return [self getChunkFromBaseData:data relativePosition:1 limit:limit];
}

- (NSUInteger)count
{
    return _forexDataArray.count;
}

@end
