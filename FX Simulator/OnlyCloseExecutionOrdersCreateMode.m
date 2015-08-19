//
//  OnlyCloseExecutionOrdersCreateMode.m
//  FX Simulator
//
//  Created  on 2014/11/22.
//  
//

#import "OnlyCloseExecutionOrdersCreateMode.h"

#import "OpenPosition.h"
#import "ExecutionOrderMaterial.h"
#import "OpenPositionRecord.h"
#import "CloseExecutionOrder.h"

@implementation OnlyCloseExecutionOrdersCreateMode {
    //OpenPosition *openPosition;
}

/*-(id)init
{
    if (self = [super init]) {
        openPosition = [OpenPositionFactory createOpenPosition];
    }
    
    return self;
}*/

-(NSArray*)create:(ExecutionOrderMaterial*)order
{
    [super create:nil];
    
    NSArray *openPositionRecordArray = [super.openPosition selectLimitPositionSize:order.positionSize];
    
    NSMutableArray *executionOrders = [NSMutableArray array];
    
    for (OpenPositionRecord *record in openPositionRecordArray) {
        CloseExecutionOrder *executionOrder = [[CloseExecutionOrder alloc] initWithExecutionOrderMaterial:order OpenPositionRecord:record];
        //CloseExecutionOrder *executionOrder = [[CloseExecutionOrder alloc] initWithForexHistoryData:order.forexHistoryData orderType:order.orderType positionSize:record.positionSize closeOpenPositionNumber:record.openPositionNumber closeUsersOrderNumber:record.orderNumber closeOrderRate:record.orderRate isCloseAll:record.isAllPositionSize];
        [executionOrders addObject:executionOrder];
    }
    
    return [executionOrders copy];
}

@end
