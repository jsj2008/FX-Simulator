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
    if (order.isNew || order.isClose) {
        return nil;
    }
    
    return @[[order copyOrderForNewOrder]];
}

@end
