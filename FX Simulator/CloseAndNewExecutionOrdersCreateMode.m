//
//  CloseAndNewExecutionOrdersCreateMode.m
//  FX Simulator
//
//  Created  on 2014/11/22.
//  
//

#import "CloseAndNewExecutionOrdersCreateMode.h"

#import "ExecutionOrder.h"
#import "OnlyCloseExecutionOrdersCreateMode.h"
#import "OnlyNewExecutionOrdersCreateMode.h"
#import "OpenPosition.h"
#import "Order.h"
#import "PositionSize.h"

@implementation CloseAndNewExecutionOrdersCreateMode {
    OnlyCloseExecutionOrdersCreateMode *closeMode;
    OnlyNewExecutionOrdersCreateMode *newMode;
}

- (NSArray *)create:(Order *)order
{
    [super create:nil];
    
    PositionSize *closePositionSize = [OpenPosition totalPositionSizeOfCurrencyPair:order.currencyPair];
    PositionSize *newPositionSize = [[PositionSize alloc] initWithSizeValue:order.positionSize.sizeValue - closePositionSize.sizeValue];
    
    Order *closeOrder = [order copyOrderNewPositionSize:closePositionSize];
    Order *newOrder = [order copyOrderNewPositionSize:newPositionSize];
    
    NSArray *closeOrders = [closeMode create:closeOrder];
    NSArray *newOrders = [newMode create:newOrder];
    
    return [closeOrders arrayByAddingObjectsFromArray:newOrders];
}

@end
