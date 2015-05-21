//
//  OnlyNewExecutionOrdersCreateMode.m
//  FX Simulator
//
//  Created  on 2014/11/22.
//  
//

#import "OnlyNewExecutionOrdersCreateMode.h"
#import "ExecutionOrderMaterial.h"
#import "NewExecutionOrder.h"

@implementation OnlyNewExecutionOrdersCreateMode

-(NSArray*)create:(ExecutionOrderMaterial*)order
{
    [super create:nil];
    
    NSMutableArray *executionOrders = [NSMutableArray array];
    
    NewExecutionOrder *executionOrder = [[NewExecutionOrder alloc] initWithExecutionOrderMaterial:order];
    //[executionOrder copy:order];
    [executionOrders addObject:executionOrder];
    
    return [executionOrders copy];
}

@end
