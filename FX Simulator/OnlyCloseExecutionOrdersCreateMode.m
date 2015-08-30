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
#import "OpenPositionRecord.h"

@implementation OnlyCloseExecutionOrdersCreateMode

- (NSArray *)create:(Order *)order
{
    [super create:nil];
    
    NSArray *openPositionRecordArray = [super.openPosition selectLimitPositionSize:order.positionSize];
    
    NSMutableArray *executionOrders = [NSMutableArray array];
    
    for (OpenPositionRecord *record in openPositionRecordArray) {
        ExecutionOrder *executionOrder = [ExecutionOrder createCloseExecutionOrderFromOrder:order];
        executionOrder.closeTargetExecutionHistoryId = record.executionHistoryId;
        executionOrder.closeTargetOrderHistoryId = record.orderHistoryId;
        executionOrder.closeTargetOpenPositionId = record.openPositionId;
        executionOrder.positionSize = record.positionSize;
        [executionOrders addObject:executionOrder];
    }
    
    return [executionOrders copy];
}

@end
