//
//  ExecutionOrder.h
//  FX Simulator
//
//  Created  on 2014/11/23.
//  
//

#import "Order.h"

@class Money;
@class OrderHistory;
@class PositionSize;

@interface ExecutionOrder : Order

@property (nonatomic) NSUInteger executionHistoryId;

@property (nonatomic , readonly) BOOL isClose;
@property (nonatomic) NSUInteger closeTargetExecutionHistoryId;
@property (nonatomic) NSUInteger closeTargetOrderHistoryId;
@property (nonatomic) NSUInteger closeTargetOpenPositionId;
@property (nonatomic, readonly) Money *profitAndLoss;

/**
 新規注文(決済注文ではない)をOrderから作成する。
*/
+ (instancetype)createNewExecutionOrderFromOrder:(Order *)order;

/**
 決済注文(新規注文ではない)をOrderから作成する。
*/
+ (instancetype)createCloseExecutionOrderFromOrder:(Order *)order;

- (instancetype)initWithFMResultSet:(FMResultSet *)result orderHistory:(OrderHistory *)orderHistory;

@end
