//
//  ExecutionOrdersCreateModeFactory.m
//  FX Simulator
//
//  Created  on 2014/11/22.
//  
//

#import "OrdersCreateModeFactory.h"

#import "CloseAndNewOrdersCreateMode.h"
#import "Common.h"
#import "OnlyCloseOrdersCreateMode.h"
#import "OnlyNewOrdersCreateMode.h"
#import "OpenPosition.h"
#import "Order.h"
#import "PositionSize.h"
#import "PositionType.h"

@implementation OrdersCreateModeFactory

#warning positionsize
+ (OrdersCreateMode *)createModeFromOrder:(Order *)order
{
    OrdersCreateMode *onlyClose = [OnlyCloseOrdersCreateMode new];
    OrdersCreateMode *onlyNew = [OnlyNewOrdersCreateMode new];
    OrdersCreateMode *closeAndNew = [CloseAndNewOrdersCreateMode new];
    
    PositionType *positionType = [OpenPosition positionTypeOfCurrencyPair:order.currencyPair];
    position_size_t totalPositionSize = [OpenPosition totalPositionSizeOfCurrencyPair:order.currencyPair].sizeValue;
    
    if (totalPositionSize == 0) {
        return onlyNew;
    } else if ([positionType isEqualOrderType:order.positionType]) {
        return onlyNew;
    } else {
        if (order.positionSize.sizeValue <= totalPositionSize) {
            return onlyClose;
        } else if (totalPositionSize < order.positionSize.sizeValue) {
            return closeAndNew;
        }
    }
    
    return nil;
}

@end
