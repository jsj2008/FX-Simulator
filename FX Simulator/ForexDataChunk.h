//
//  ForexDataArray.h
//  FX Simulator
//
//  Created by yuu on 2015/07/04.
//
//

#import <Foundation/Foundation.h>

@class ForexHistoryData;
@class Rate;

@interface ForexDataChunk : NSObject
- (instancetype)initWithForexDataArray:(NSArray *)array;
- (void)enumerateObjectsUsingBlock:(void (^)(ForexHistoryData *obj, NSUInteger idx))block;
- (ForexDataChunk *)getForexDataLimit:(NSUInteger)limit;
- (double)minRate;
- (double)maxRate;
@property (nonatomic, readonly) NSUInteger count;
@property (nonatomic, readonly) ForexHistoryData *current;
@end
