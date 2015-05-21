//
//  ProfitAndLoss.h
//  FX Simulator
//
//  Created  on 2014/12/04.
//  
//

#import <Foundation/Foundation.h>

@class Money;
@class Rate;
@class PositionSize;
@class OrderType;

@interface ProfitAndLossCalculator : NSObject
// TargetRate = 元のレート, ValuationRate = 現在の評価レート
+(Money*)calculateByTargetRate:(Rate*)targetRate valuationRate:(Rate*)valuationRate positionSize:(PositionSize*)positionSize orderType:(OrderType*)orderType;
@end
