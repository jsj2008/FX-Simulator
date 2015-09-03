//
//  OpenPositionRecord.h
//  FX Simulator
//
//  Created  on 2014/07/15.
//  
//

#import "Order.h"

@class FMResultSet;
@class OrderHistory;
@class ExecutionHistoryRecord;
@class CurrencyPair;
@class Market;
@class PositionType;
@class Rate;
@class PositionSize;
@class Spread;
@class Money;

@interface OpenPositionRecord : Order
@property (nonatomic, readonly) NSUInteger executionHistoryId;
@property (nonatomic, readonly) NSUInteger openPositionId;
- (instancetype)initWithFMResultSet:(FMResultSet *)result orderHistory:(OrderHistory *)orderHistory;
//- (instancetype)initWithNewExecutionOrder:(NewExecutionOrder *)order;
//- (instancetype)initWithOpenPositionRawRecord:(OpenPositionRawRecord *)rawRecord executionHistoryRecord:(ExecutionHistoryRecord *)record;
- (Money *)profitAndLossForMarket:(Market *)market;
//@property (nonatomic) BOOL isAllPositionSize;
@end
