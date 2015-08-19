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
#import "OpenPosition.h"
#import "ExecutionHistory.h"

@implementation ExecutionOrdersTransactionManager {
    OpenPosition *_openPosition;
    ExecutionHistory *_executionHistory;
    BOOL _isStart;
    NSMutableArray *_targets;
}

-(id)initWithOpenPosition:(OpenPosition *)openPosition executionHistory:(ExecutionHistory *)executionHistory
{
    if (self = [super init]) {
        _openPosition = openPosition;
        _executionHistory = executionHistory;
        _targets = [NSMutableArray array];
        [self addTransactionTarget:_openPosition];
        [self addTransactionTarget:_executionHistory];
    }
    
    return self;
}

-(void)addTransactionTarget:(id<ExecutionOrdersTransactionTarget>)target
{
    [_targets addObject:target];
}

-(BOOL)execute:(NSArray *)orders
{
    FMDatabase *db = [TradeDatabase dbConnect];
    
    [self start:db];
    
    NSArray *executionOrders = [_executionHistory saveOrders:orders db:db];
    
    if (executionOrders != nil) {
        if (![_openPosition execute:executionOrders db:db]) {
            [self rollback:db];
            
            return NO;
        }
    } else {
        [self rollback:db];
        
        return NO;
    }
    
    [self commit:db];
    
    return YES;
}

-(void)start:(FMDatabase *)db
{
    if (_isStart == NO) {
        
        _isStart = YES;
        
        for (id<ExecutionOrdersTransactionTarget> target in _targets) {
            target.inExecutionOrdersTransaction = YES;
        }
        
        [db open];
        [db beginTransaction];
    }
}

-(void)commit:(FMDatabase *)db
{
    if (_isStart == YES) {
        [db commit];
        [self end:db];
    }
}

-(void)rollback:(FMDatabase *)db
{
    if (_isStart == YES) {
        [db rollback];
        [self end:db];
    }
}

-(void)end:(FMDatabase *)db
{
    if (_isStart == YES) {
        
        _isStart = NO;
        
        for (id<ExecutionOrdersTransactionTarget> target in _targets) {
            target.inExecutionOrdersTransaction = NO;
        }
        
        [db close];
    }
}


@end
