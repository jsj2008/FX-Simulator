//
//  OnlyCloseExecutionOrdersCreateMode.m
//  FX Simulator
//
//  Created  on 2014/11/22.
//  
//

#import "OnlyCloseOrdersCreateMode.h"

#import "ExecutionOrder.h"
#import "OpenPosition.h"
#import "Order.h"

@implementation OnlyCloseOrdersCreateMode

- (NSArray *)create:(Order *)order
{
    if (order.isNew) {
        return nil;
    }
    
    if (order.isClose) {
        return @[order];
    } else {
        [order setCloseOrder];
        return @[order];
    }
}

@end
