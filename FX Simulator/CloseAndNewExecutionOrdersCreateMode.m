//
//  CloseAndNewExecutionOrdersCreateMode.m
//  FX Simulator
//
//  Created  on 2014/11/22.
//  
//

#import "CloseAndNewExecutionOrdersCreateMode.h"

#import "OpenPosition.h"
#import "Order.h"
#import "ExecutionOrderMaterial.h"
#import "OnlyCloseExecutionOrdersCreateMode.h"
#import "OnlyNewExecutionOrdersCreateMode.h"
#import "PositionSize.h"

@implementation CloseAndNewExecutionOrdersCreateMode {
    OnlyCloseExecutionOrdersCreateMode *closeMode;
    OnlyNewExecutionOrdersCreateMode *newMode;
}

-(id)initWithOpenPosition:(OpenPosition *)openPosition
{
    if (self = [super initWithOpenPosition:openPosition]) {
        closeMode = [[OnlyCloseExecutionOrdersCreateMode alloc] initWithOpenPosition:openPosition];
        newMode = [[OnlyNewExecutionOrdersCreateMode alloc] initWithOpenPosition:openPosition];
    }
    
    return self;
}

-(NSArray*)create:(ExecutionOrderMaterial*)order
{
    [super create:nil];
    
    PositionSize *closePositionSize = super.openPosition.totalPositionSize;
    PositionSize *newPositionSize = [[PositionSize alloc] initWithSizeValue:order.positionSize.sizeValue - closePositionSize.sizeValue];
    
    Order *closeOrder = [[ExecutionOrderMaterial alloc] initWithCurrencyPair:order.currencyPair orderType:order.orderType orderRate:order.orderRate positionSize:closePositionSize orderSpread:order.orderSpread];
    Order *newOrder = [[ExecutionOrderMaterial alloc] initWithCurrencyPair:order.currencyPair orderType:order.orderType orderRate:order.orderRate positionSize:newPositionSize orderSpread:order.orderSpread];
    
    ExecutionOrderMaterial *closeOrderMaterial = [[ExecutionOrderMaterial alloc] initWithOrder:closeOrder usersOrderNumber:order.usersOrderNumber];
    ExecutionOrderMaterial *newOrderMaterial = [[ExecutionOrderMaterial alloc] initWithOrder:newOrder usersOrderNumber:order.usersOrderNumber];
    
    NSArray *closeOrders = [closeMode create:closeOrderMaterial];
    NSArray *newOrders = [newMode create:newOrderMaterial];
    
    return [closeOrders arrayByAddingObjectsFromArray:newOrders];
}

@end
