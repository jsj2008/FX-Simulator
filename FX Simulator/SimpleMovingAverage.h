//
//  SimpleMovingAverage.h
//  FX Simulator
//
//  Created by yuu on 2015/07/04.
//
//

#import <Foundation/Foundation.h>
#import "Indicator.h"


@interface SimpleMovingAverage : NSObject <Indicator>
- (void)strokeIndicatorFromForexDataArray:(ForexDataArray *)array displayPointCount:(NSInteger)count displaySize:(CGSize)size;
@end
