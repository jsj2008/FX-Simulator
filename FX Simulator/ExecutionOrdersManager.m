//
//  ExecutionOrdersManager.m
//  FX Simulator
//
//  Created  on 2014/11/24.
//  
//

#import "ExecutionOrdersManager.h"
#import "ExecutionOrdersTransactionManager.h"
#import "OpenPositionManagerFactory.h"
#import "OpenPositionManager.h"
#import "ExecutionHistoryManagerFactory.h"
#import "ExecutionHistoryManager.h"
//#import "OpenPositionFactory.h"
//#import "OpenPosition.h"
//#import "ExecutionHistoryFactory.h"
//#import "ExecutionHistory.h"
#import "CloseExecutionOrder.h"
#import "NewExecutionOrder.h"

@implementation ExecutionOrdersManager {
    ExecutionOrdersTransactionManager *_transactionManager;
}

/*-(id)init
{
    if (self = [super init]) {
        transactionManager = [ExecutionOrdersTransactionManager new];
        OpenPositionManager *openPositionManager = [OpenPositionManagerFactory createOpenPositionManager];
        ExecutionHistoryManager *executionHistoryManager = [ExecutionHistoryManagerFactory createExecutionHistoryManager];
        [transactionManager addTransactionTarget:openPositionManager];
        [transactionManager addTransactionTarget:executionHistoryManager];
    }
    
    return self;
}*/

-(id)initWithOpenPositionManager:(OpenPositionManager *)openPositionManager executionHistoryManager:(ExecutionHistoryManager *)executionHistoryManager
{
    if (self = [super init]) {
        _transactionManager = [[ExecutionOrdersTransactionManager alloc] initWithOpenPositionManager:openPositionManager executionHistoryManager:executionHistoryManager];
        //transactionManager = [ExecutionOrdersTransactionManager new];
        //[transactionManager addTransactionTarget:openPositionManager];
        //[transactionManager addTransactionTarget:executionHistoryManager];
    }
    
    return self;
}

-(BOOL)executeOrders:(NSArray*)orders
{
    return [_transactionManager execute:orders];
    
    //[transactionManager addTransactionTarget:openPositionManager];
    //[transactionManager addTransactionTarget:executionHistoryManager];
    
    //[transactionManager start];
    
    /*BOOL isSuccess;
    
    for (id order in orders) {
        if ([order isKindOfClass:[CloseExecutionOrder class]]) {
            isSuccess = [openPositionManager closeOpenPosition:order];
        } else if ([order isKindOfClass:[NewExecutionOrder class]]) {
            isSuccess = [openPositionManager newOpenPosition:order];
        } else {
            return NO;
        }
        
        if (!isSuccess) {
            [transactionManager rollback];
            return NO;
        }
    }*/
    
    /*if([executionHistoryManager saveExecutionOrders:orders]) {
        [transactionManager commit];
        return YES;
    } else {
        [transactionManager rollback];
        return NO;
    }*/
}

@end
