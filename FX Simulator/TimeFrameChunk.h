//
//  TimeFrameChunk.h
//  FXSimulator
//
//  Created by yuu on 2015/08/10.
//
//

#import <Foundation/Foundation.h>

@class TimeFrame;

@interface TimeFrameChunk : NSObject

@property (nonatomic, readonly) TimeFrame *minTimeFrame;

- (instancetype)initWithTimeFrameArray:(NSArray *)timeframes;
- (void)enumerateTimeFrames:(void (^)(TimeFrame *timeFrame))block;
- (void)enumerateTimeFrames:(void (^)(NSUInteger idx, TimeFrame *timeFrame))block execept:(TimeFrame *)execeptTimeFrame;
- (TimeFrameChunk *)getTimeFrameChunkExecept:(TimeFrame *)execeptTimeFrame;
- (NSUInteger)indexOfTimeFrame:(TimeFrame *)timeFrame;
- (TimeFrame *)timeFrameAtIndex:(NSUInteger)index;
- (NSUInteger)count;

@end
