//
//  SimpleMovingAverage.h
//  FX Simulator
//
//  Created by yuu on 2015/07/04.
//
//

#import <Foundation/Foundation.h>
#import "Indicator.h"

@class MovingAverageSource;

@interface MovingAverage : Indicator
@property (nonatomic) UIColor *lineColor;
@property (nonatomic) NSUInteger period;
- (instancetype)initWithMovingAverageSource:(MovingAverageSource *)source;
- (void)strokeIndicatorFromForexDataChunk:(ForexDataChunk *)chunk displayForexDataCount:(NSInteger)count displaySize:(CGSize)size;
@end
