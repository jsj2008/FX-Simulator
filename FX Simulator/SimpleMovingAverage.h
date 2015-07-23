//
//  SimpleMovingAverage.h
//  FX Simulator
//
//  Created by yuu on 2015/07/04.
//
//

#import <Foundation/Foundation.h>
#import "Indicator.h"

@class SimpleMovingAveragePlistSource;

@interface SimpleMovingAverage : Indicator
- (instancetype)initWithSource:(SimpleMovingAveragePlistSource *)source;
- (void)strokeIndicatorFromForexDataChunk:(ForexDataChunk *)chunk displayForexDataCount:(NSInteger)count displaySize:(CGSize)size;
@end
