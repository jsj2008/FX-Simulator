//
//  CloseAndNewExecutionOrdersCreateMode.m
//  FX Simulator
//
//  Created  on 2014/11/22.
//  
//

#import "CloseAndNewOrdersCreateMode.h"

#import "OnlyCloseOrdersCreateMode.h"
#import "OnlyNewOrdersCreateMode.h"
#import "OpenPosition.h"
#import "Order.h"
#import "PositionSize.h"

@implementation CloseAndNewOrdersCreateMode {
    OnlyCloseOrdersCreateMode *_closeMode;
    OnlyNewOrdersCreateMode *_newMode;
}

- (instancetype)init
{
    if (self = [super init]) {
        _closeMode = [OnlyCloseOrdersCreateMode new];
        _newMode = [OnlyNewOrdersCreateMode new];
    }
    
    return self;
}

- (NSArray *)create:(Order *)order
{
    if (order.isNew || order.isClose) {
        return nil;
    }
    
    PositionSize *closePositionSize = [OpenPosition totalPositionSizeOfCurrencyPair:order.currencyPair];
    PositionSize *newPositionSize = [[PositionSize alloc] initWithSizeValue:order.positionSize.sizeValue - closePositionSize.sizeValue];
    
    Order *closeOrder = [order copyOrderForNewPositionSize:closePositionSize];
    Order *newOrder = [order copyOrderForNewPositionSize:newPositionSize];
    
    NSArray *closeOrders = [_closeMode create:closeOrder];
    NSArray *newOrders = [_newMode create:newOrder];
    
    if (!closeOrders.count || !newOrders.count) {
        return nil;
    }
    
    return [closeOrders arrayByAddingObjectsFromArray:newOrders];
}

@end
