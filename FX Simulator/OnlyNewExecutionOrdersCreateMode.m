//
//  OnlyNewExecutionOrdersCreateMode.m
//  FX Simulator
//
//  Created  on 2014/11/22.
//  
//

#import "OnlyNewExecutionOrdersCreateMode.h"

#import "ExecutionOrder.h"

@implementation OnlyNewExecutionOrdersCreateMode

- (NSArray *)create:(Order *)order
{
    [super create:nil];
    
    NSMutableArray *executionOrders = [NSMutableArray array];
    
    ExecutionOrder *executionOrder = [ExecutionOrder createNewExecutionOrderFromOrder:order];
    [executionOrders addObject:executionOrder];
    
    return [executionOrders copy];
}

@end
