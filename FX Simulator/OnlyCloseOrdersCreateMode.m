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
    if (order.isNew || order.isClose) {
        return nil;
    }
    
    return @[[order copyOrderForCloseOrder]];
}

@end
