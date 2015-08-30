//
//  ExecutionOrder.m
//  FX Simulator
//
//  Created  on 2014/11/23.
//  
//

#import "ExecutionOrder.h"

#import "FMResultSet.h"
#import "ExecutionHistory.h"
#import "OrderHistory.h"
#import "ProfitAndLossCalculator.h"

@interface ExecutionOrder ()
@property (nonatomic) BOOL isClose;
@end

@implementation ExecutionOrder

+ (instancetype)createNewExecutionOrderFromOrder:(Order *)order
{
    return [[[self class] alloc] initWithOrder:order];
}

+ (instancetype)createCloseExecutionOrderFromOrder:(Order *)order
{
    ExecutionOrder *executionOrder = [[[self class] alloc] initWithOrder:order];
    
    executionOrder.isClose = YES;
    
    return executionOrder;
}

- (instancetype)initWithFMResultSet:(FMResultSet *)resultSet
{
    return nil;
}

- (instancetype)initWithFMResultSet:(FMResultSet *)result orderHistory:(OrderHistory *)orderHistory
{
    NSUInteger orderHistoryId = [result intForColumn:@"order_history_id"];
    
    Order *order = [orderHistory getOrderFromOrderHistoryId:orderHistoryId];
    
    if (!order) {
        return nil;
    }
    
    if (self = [self initWithOrder:order]) {
        _executionHistoryId = [result intForColumn:@"id"];
        _isClose = [result boolForColumn:@"is_close"];
        _closeTargetExecutionHistoryId = [result intForColumn:@"close_target_execution_history_id"];
        _closeTargetOrderHistoryId = [result intForColumn:@"close_target_order_history_id"];
    }
    
    return self;
}

- (instancetype)initWithOrder:(Order *)order
{
    if (self = [super initWithOrderHistoryId:order.orderHistoryId CurrencyPair:order.currencyPair orderType:order.orderType orderRate:order.orderRate positionSize:order.positionSize orderSpread:order.orderSpread]) {
        _isClose = NO;
    }
    
    return self;
}

- (Money *)profitAndLoss
{
    if (!self.isClose) {
        return nil;
    }
    
    ExecutionHistory *executionHistory = [ExecutionHistory loadExecutionHistory];
    
    ExecutionOrder *closeTargetOrder = [executionHistory orderAtExecutionHistoryId:self.closeTargetExecutionHistoryId];
    
    if (!closeTargetOrder) {
        return nil;
    }
    
    return [ProfitAndLossCalculator calculateByTargetRate:self.orderRate valuationRate:closeTargetOrder.orderRate positionSize:self.positionSize orderType:self.orderType];
}

@end
