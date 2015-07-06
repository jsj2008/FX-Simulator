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
        _count = _forexDataArray.count;
    }

    return self;
}

- (void)enumerateObjectsUsingBlock:(void (^)(ForexHistoryData *, NSUInteger))block
{
    [_forexDataArray enumerateObjectsUsingBlock:^(ForexHistoryData *obj, NSUInteger idx, BOOL *stop) {
        block(obj, idx);
    }];
}

- (ForexDataChunk *)getForexDataLimit:(NSUInteger)limit
{
    if ([self count] == 0 || limit == 0) {
        return nil;
    }
    
    if ([self count] < limit) {
        limit = [self count];
    }
    
    return [self initWithForexDataArray:[_forexDataArray subarrayWithRange:NSMakeRange(0, limit)]];
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
