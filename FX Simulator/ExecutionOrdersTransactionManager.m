//
//  ExecutionOrdersTransactionManager.m
//  FX Simulator
//
//  Created  on 2014/11/25.
//  
//

#import "ExecutionOrdersTransactionManager.h"

#import "FMDatabase.h"
#import "TradeDatabase.h"
#import "OpenPositionManager.h"
#import "ExecutionHistoryManager.h"

@implementation ExecutionOrdersTransactionManager {
    FMDatabase *_tradeDB;
    OpenPositionManager *_openPositionManager;
    ExecutionHistoryManager *_executionHistoryManager;
    BOOL _isStart;
    NSMutableArray *_targets;
}

-(id)initWithOpenPositionManager:(OpenPositionManager *)openPositionManager executionHistoryManager:(ExecutionHistoryManager *)executionHistoryManager
{
    if (self = [super init]) {
        _tradeDB = [TradeDatabase dbConnect];
        _openPositionManager = openPositionManager;
        _executionHistoryManager = executionHistoryManager;
        _targets = [NSMutableArray array];
        [self addTransactionTarget:_openPositionManager];
        [self addTransactionTarget:_executionHistoryManager];
    }
    
    return self;
}

-(void)addTransactionTarget:(id<ExecutionOrdersTransactionTarget>)target
{
    [_targets addObject:target];
}

-(BOOL)execute:(NSArray *)orders
{
    [self start];
    
    NSArray *executionOrders = [_executionHistoryManager saveOrders:orders];
    
    if (executionOrders != nil) {
        if (![_openPositionManager execute:executionOrders]) {
            [self rollback];
            
            return NO;
        }
    } else {
        [self rollback];
        
        return NO;
    }
    
    [self commit];
    
    return YES;
}

-(void)start
{
    if (_isStart == NO) {
        
        _isStart = YES;
        
        for (id<ExecutionOrdersTransactionTarget> target in _targets) {
            target.inExecutionOrdersTransaction = YES;
        }
        
        [_tradeDB open];
        [_tradeDB beginTransaction];
    }
}

-(void)commit
{
    if (_isStart == YES) {
        [_tradeDB commit];
        [self end];
    }
}

-(void)rollback
{
    if (_isStart == YES) {
        [_tradeDB rollback];
        [self end];
    }
}

-(void)end
{
    if (_isStart == YES) {
        
        _isStart = NO;
        
        for (id<ExecutionOrdersTransactionTarget> target in _targets) {
            target.inExecutionOrdersTransaction = NO;
        }
        
        [_tradeDB close];
    }
}


@end
