//
//  ExecutionOrdersManager.m
//  FX Simulator
//
//  Created  on 2014/11/24.
//  
//

#import "ExecutionOrdersManager.h"

#import "ExecutionOrdersTransactionManager.h"
#import "OpenPosition.h"
#import "ExecutionHistory.h"

@implementation ExecutionOrdersManager {
    ExecutionOrdersTransactionManager *_transactionManager;
}

- (instancetype)initWithOpenPosition:(OpenPosition *)openPosition executionHistory:(ExecutionHistory *)executionHistory
{
    if (self = [super init]) {
        _transactionManager = [[ExecutionOrdersTransactionManager alloc] initWithOpenPosition:openPosition executionHistory:executionHistory];
    }
    
    return self;
}

- (BOOL)executeOrders:(NSArray*)orders
{
    return [_transactionManager execute:orders];
}

@end
