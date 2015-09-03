//
//  OnlyCloseExecutionOrdersCreateMode.m
//  FX Simulator
//
//  Created  on 2014/11/22.
//  
//

#import "OnlyCloseExecutionOrdersCreateMode.h"

#import "ExecutionOrder.h"
#import "OpenPosition.h"
#import "Order.h"

@implementation OnlyCloseExecutionOrdersCreateMode

- (NSArray *)create:(Order *)order
{
    [super create:nil];
    
    NSArray *openPositions = [OpenPosition selectCloseTargetOpenPositionsLimitClosePositionSize:order.positionSize currencyPair:order.currencyPair];
    
    NSMutableArray *executionOrders = [NSMutableArray array];
    
    for (OpenPosition *openPosition in openPositions) {
        ExecutionOrder *executionOrder = [ExecutionOrder createCloseExecutionOrderFromCloseTargetOpenPosition:openPosition order:order];
        [executionOrders addObject:executionOrder];
    }
    
    return [executionOrders copy];
}

@end
