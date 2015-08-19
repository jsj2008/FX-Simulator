//
//  OrderManager.m
//  FX Simulator
//
//  Created  on 2014/09/11.
//  
//

#import "OrderManager.h"

#import "UsersOrder.h"
#import "OrderHistory.h"
#import "OpenPosition.h"
#import "ExecutionHistory.h"
#import "OrderManagerState.h"
#import "ExecutionOrderMaterial.h"
#import "ExecutionOrdersFactory.h"
#import "ExecutionOrdersManager.h"

@implementation OrderManager {
    OrderHistory *_orderHistory;
    OrderManagerState *_orderManagerState;
    ExecutionOrdersFactory *_executionOrdersFactory;
    ExecutionOrdersManager *_executionOrdersManager;
}

+ (instancetype)createOrderManager
{    
    OrderHistory *orderHistory = [OrderHistory loadOrderHistory];
    OpenPosition *openPosition = [OpenPosition loadOpenPosition];
    ExecutionHistory *executionHistory = [ExecutionHistory loadExecutionHistory];
    
    ExecutionOrdersFactory *executionOrdersFactory = [[ExecutionOrdersFactory alloc] initWithOpenPosition:openPosition];
    
    ExecutionOrdersManager *executionOrdersManager = [[ExecutionOrdersManager alloc] initWithOpenPosition:openPosition executionHistory:executionHistory];
    
    return [[OrderManager alloc] initWithOrderHistory:orderHistory executionOrdersFactory:executionOrdersFactory executionOrdersManager:executionOrdersManager];
}

- (instancetype)initWithOrderHistory:(OrderHistory *)orderHistory executionOrdersFactory:(ExecutionOrdersFactory *)executionOrdersFactory executionOrdersManager:(ExecutionOrdersManager *)executionOrdersManager
{
    if (self = [super init]) {
        _orderHistory = orderHistory;
        _orderManagerState = [OrderManagerState new];
        _executionOrdersFactory = executionOrdersFactory;
        _executionOrdersManager = executionOrdersManager;
    }
    
    return self;
}

- (BOOL)execute:(UsersOrder*)order
{
    [_orderManagerState updateState:order];
    
    if (![_orderManagerState isExecutable]) {
        [_orderManagerState showAlert:self.alertTarget];
        return NO;
    }
    
    int orderNumber = [_orderHistory saveUsersOrder:order];
    
    if (orderNumber < 1) {
        return false;
    }
    
    ExecutionOrderMaterial *material = [[ExecutionOrderMaterial alloc] initWithOrder:order usersOrderNumber:orderNumber];
    
    NSArray *executionOrders = [_executionOrdersFactory create:material];
    
    [_executionOrdersManager executeOrders:executionOrders];
    
    return true;
}

@end
