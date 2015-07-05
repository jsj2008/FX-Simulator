//
//  CandleChart.h
//  FX Simulator
//
//  Created by yuu on 2015/07/05.
//
//

#import <Foundation/Foundation.h>
#import "Indicator.h"

@interface CandleChart : NSObject <Indicator>
- (void)strokeIndicatorFromForexDataArray:(ForexDataArray *)array displayPointCount:(NSInteger)count displaySize:(CGSize)size;
//-(UIBezierPath*)createPathFromMarket:(Market*)market displayPointCount:(NSInteger)count displaySize:(CGSize)size;
@end
