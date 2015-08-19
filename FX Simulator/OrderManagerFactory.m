//
//  OrderManagerFactory.m
//  FX Simulator
//
//  Created  on 2014/12/17.
//  
//

#import "OrderManagerFactory.h"

#import "OrderManager.h"
#import "OpenPositionFactory.h"
#import "OpenPosition.h"
#import "OrderHistoryFactory.h"
#import "OrderHistory.h"
#import "ExecutionOrdersFactory.h"
#import "ExecutionOrdersManager.h"
#import "OpenPositionManagerFactory.h"
#import "OpenPositionManager.h"
#import "ExecutionHistoryManagerFactory.h"
#import "ExecutionHistoryManager.h"


@implementation OrderManagerFactory

+(OrderManager*)createOrderManager
{
    // create OrderHistory ユーザーのオーダーから実際のオーダーを生成するために使う
    
    OrderHistory *orderHistory = [OrderHistoryFactory createOrderHistory];
    
    // create ExecutionOrdersFactory ユーザーのオーダーから実際のオーダーを生成する
    OpenPosition *openPosition = [OpenPositionFactory createOpenPosition];
    
    ExecutionOrdersFactory *executionOrdersFactory = [[ExecutionOrdersFactory alloc] initWithOpenPosition:openPosition];
    
    // create ExecutionOrdersManager 実際のオーダーを実行する
    
    ExecutionOrdersManager *executionOrdersManager = [[ExecutionOrdersManager alloc] initWithOpenPosition:<#(OpenPosition *)#> executionHistory:<#(ExecutionHistory *)#>];
    
    
    
    return [[OrderManager alloc] initWithOrderHistory:orderHistory executionOrdersFactory:executionOrdersFactory executionOrdersManager:executionOrdersManager];
}

@end
