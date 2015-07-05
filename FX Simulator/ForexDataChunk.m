//
//  ForexDataArray.m
//  FX Simulator
//
//  Created by yuu on 2015/07/04.
//
//

#import "ForexDataChunk.h"

#import "ForexHistoryData.h"

@implementation ForexDataChunk {
    ForexHistoryData *_headForexData;
    NSArray *_forexDataArray;
}

- (instancetype)initWithHeadForexData:(ForexHistoryData *)data
{
    if (data == nil) {
        return nil;
    }
    
    if (self = [super init]) {
        _headForexData = data;
        _current = _headForexData;
        NSMutableArray *forexDataArray = [NSMutableArray array];
        [self forexDataList:_headForexData UsingBlock:^(ForexHistoryData *obj) {
            [forexDataArray addObject:obj];
        }];
        _forexDataArray = [forexDataArray copy];
        _count = _forexDataArray.count;
    }
    
    return self;
}

- (instancetype)initWithForexDataArray:(NSArray *)array
{
    __block ForexHistoryData *headData = nil;
    __block ForexHistoryData *previous;
        
    [array enumerateObjectsUsingBlock:^(ForexHistoryData *obj, NSUInteger idx, BOOL *stop) {
        if (headData == nil) {
            headData = obj;
            previous = headData;
        } else {
            previous.previous = obj;
            previous = previous.previous;
        }
    }];
    
    return [self initWithHeadForexData:headData];
}

- (void)forexDataList:(ForexHistoryData*)data UsingBlock:(void (^)(ForexHistoryData *obj))block
{
    if (data == nil) {
        return;
    }
    
    block(data);
    
    [self forexDataList:data.previous UsingBlock:block];
}

- (void)enumerateObjectsUsingBlock:(void (^)(ForexHistoryData *obj))block
{
    [self forexDataList:_headForexData UsingBlock:block];
}

- (ForexDataChunk *)getForexDataLimit:(NSUInteger)count
{
    if ([self count] == 0 || count == 0) {
        return nil;
    }
    
    NSInteger getStartIndex = [self count] - count;
    
    if ([self count] < count) {
        getStartIndex = 0;
    }
    
    return [self initWithForexDataArray:[_forexDataArray subarrayWithRange:NSMakeRange(getStartIndex, count)]];
}

- (double)maxRate
{
    return [[_forexDataArray valueForKeyPath:@"@max.high.rateValue"] doubleValue];
}

- (double)minRate
{
    return [[_forexDataArray valueForKeyPath:@"@min.low.rateValue"] doubleValue];
}

@end
