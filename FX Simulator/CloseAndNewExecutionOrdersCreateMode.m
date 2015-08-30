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

- (instancetype)initWithOpenPosition:(OpenPosition *)openPosition
{
    if (self = [super initWithOpenPosition:openPosition]) {
        closeMode = [[OnlyCloseExecutionOrdersCreateMode alloc] initWithOpenPosition:openPosition];
        newMode = [[OnlyNewExecutionOrdersCreateMode alloc] initWithOpenPosition:openPosition];
    }
    
    return self;
}

- (NSArray *)create:(Order *)order
{
    [super create:nil];
    
    PositionSize *closePositionSize = [super.openPosition totalPositionSizeOfCurrencyPair:order.currencyPair];
    PositionSize *newPositionSize = [[PositionSize alloc] initWithSizeValue:order.positionSize.sizeValue - closePositionSize.sizeValue];
    
    Order *closeOrder = [order copyOrder];
    closeOrder.positionSize = closePositionSize;
    
    Order *newOrder = [order copyOrder];
    newOrder.positionSize = newPositionSize;
    
    NSArray *closeOrders = [closeMode create:closeOrder];
    NSArray *newOrders = [newMode create:newOrder];
    
    return [closeOrders arrayByAddingObjectsFromArray:newOrders];
}

@end
