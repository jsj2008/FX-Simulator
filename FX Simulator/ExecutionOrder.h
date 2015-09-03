//
//  ExecutionOrder.h
//  FX Simulator
//
//  Created  on 2014/11/23.
//  
//

#import "PositionBase.h"

@class FMResultSet;
@class CurrencyPair;
@class Money;
@class OpenPosition;
@class Order;

@interface ExecutionOrder : PositionBase

@property (nonatomic, readonly) NSUInteger orderId;
@property (nonatomic, readonly) Money *profitAndLoss;
@property (nonatomic, readonly) NSUInteger closeTargetOrderId;

/**
 新規注文(決済注文ではない)をOrderから作成する。
*/
+ (instancetype)createNewExecutionOrderFromOrder:(Order *)order;

/**
 決済注文(新規注文ではない)をOrderから作成する。
*/
+ (instancetype)createCloseExecutionOrderFromCloseTargetOpenPosition:(OpenPosition *)openPosition order:(Order *)order;

+ (ExecutionOrder *)orderAtId:(NSUInteger)recordId;

+ (Money *)profitAndLossOfCurrencyPair:(CurrencyPair *)currencyPair;

+ (NSArray *)selectNewestFirstLimit:(NSUInteger)limit;

- (instancetype)initWithFMResultSet:(FMResultSet *)result;

- (void)execute;

- (Money *)profitAndLoss;

@end
