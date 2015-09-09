//
//  OnlyNewExecutionOrdersCreateMode.m
//  FX Simulator
//
//  Created  on 2014/11/22.
//  
//

#import "OnlyNewOrdersCreateMode.h"

#import "Order.h"

@implementation OnlyNewOrdersCreateMode

- (NSArray *)create:(Order *)order
{
    if (order.isClose) {
        return nil;
    }
    
    if (order.isNew) {
        return @[order];
    } else {
        [order setNewOrder];
        return @[order];
    }
}

@end
