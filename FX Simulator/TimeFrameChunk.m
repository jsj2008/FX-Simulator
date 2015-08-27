//
//  TimeFrameChunk.m
//  FXSimulator
//
//  Created by yuu on 2015/08/10.
//
//

#import "TimeFrameChunk.h"

#import "TimeFrame.h"

@implementation TimeFrameChunk {
    NSArray *_timeFrames;
}

- (instancetype)initWithTimeFrameArray:(NSArray *)timeframes
{
    if (self = [super init]) {
        _timeFrames = timeframes;
    }
    
    return self;
}

- (void)enumerateTimeFrames:(void (^)(TimeFrame *timeFrame))block
{
    [_timeFrames enumerateObjectsUsingBlock:^(TimeFrame *obj, NSUInteger idx, BOOL *stop) {
        block(obj);
    }];
}

- (void)enumerateTimeFrames:(void (^)(NSUInteger, TimeFrame *))block execept:(TimeFrame *)execeptTimeFrame
{
    __block NSUInteger idx = 0;
    
    [self enumerateTimeFrames:^(TimeFrame *timeFrame) {
        if (execeptTimeFrame.minute != timeFrame.minute) {
            block(idx, timeFrame);
            idx++;
        }
    }];
}

- (TimeFrameChunk *)getTimeFrameChunkExecept:(TimeFrame *)execeptTimeFrame
{
    __block NSMutableArray *array = [NSMutableArray array];
    
    [self enumerateTimeFrames:^(NSUInteger idx, TimeFrame *timeFrame) {
        [array addObject:timeFrame];
    } execept:execeptTimeFrame];
    
    return [[TimeFrameChunk alloc] initWithTimeFrameArray:[array copy]];
}

- (NSUInteger)indexOfTimeFrame:(TimeFrame *)timeFrame
{
    return [_timeFrames indexOfObject:timeFrame];
}

- (TimeFrame *)timeFrameAtIndex:(NSUInteger)index
{
    return [_timeFrames objectAtIndex:index];
}

- (NSUInteger)count
{
    return [_timeFrames count];
}

- (TimeFrame *)minTimeFrame
{
    NSArray *array = [_timeFrames sortedArrayUsingSelector:@selector(compare:)];
    
    return array.firstObject;
}

@end
