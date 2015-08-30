//
//  ExecutionOrdersCreateModeFactory.m
//  FX Simulator
//
//  Created  on 2014/11/22.
//  
//

#import "ExecutionOrdersCreateModeFactory.h"

#import "OpenPosition.h"
#import "Order.h"
#import "OrderType.h"
#import "OnlyCloseExecutionOrdersCreateMode.h"
#import "OnlyNewExecutionOrdersCreateMode.h"
#import "CloseAndNewExecutionOrdersCreateMode.h"
#import "Common.h"
#import "PositionSize.h"

@implementation ExecutionOrdersCreateModeFactory {
    OpenPosition *_openPosition;
    ExecutionOrdersCreateMode *onlyClose;
    ExecutionOrdersCreateMode *onlyNew;
    ExecutionOrdersCreateMode *closeAndNew;
}

-(id)init
{
    return nil;
}

- (instancetype)initWithOpenPosition:(OpenPosition *)openPosition
{
    if (self = [super init]) {
        _openPosition = openPosition;
        //openPosition = [OpenPositionFactory createOpenPosition];
        onlyClose = [[OnlyCloseExecutionOrdersCreateMode alloc] initWithOpenPosition:_openPosition];
        onlyNew = [[OnlyNewExecutionOrdersCreateMode alloc] initWithOpenPosition:_openPosition];
        closeAndNew = [[CloseAndNewExecutionOrdersCreateMode alloc] initWithOpenPosition:_openPosition];
    }
    
    return self;
}

#warning positionsize
- (ExecutionOrdersCreateMode *)createMode:(Order *)order
{
    [_openPosition update];
    
    OrderType *orderType = [_openPosition orderTypeOfCurrencyPair:order.currencyPair];
    position_size_t totalPositionSize = [_openPosition totalPositionSizeOfCurrencyPair:order.currencyPair].sizeValue;
    
    if (totalPositionSize == 0) {
        return onlyNew;
    } else if ([orderType isEqualOrderType:order.orderType]) {
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
