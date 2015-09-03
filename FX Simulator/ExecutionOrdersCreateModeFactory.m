//
//  ExecutionOrdersCreateModeFactory.m
//  FX Simulator
//
//  Created  on 2014/11/22.
//  
//

#import "ExecutionOrdersCreateModeFactory.h"

#import "CloseAndNewExecutionOrdersCreateMode.h"
#import "Common.h"
#import "OnlyCloseExecutionOrdersCreateMode.h"
#import "OnlyNewExecutionOrdersCreateMode.h"
#import "OpenPosition.h"
#import "Order.h"
#import "PositionSize.h"
#import "PositionType.h"

@implementation ExecutionOrdersCreateModeFactory {
    ExecutionOrdersCreateMode *_onlyClose;
    ExecutionOrdersCreateMode *_onlyNew;
    ExecutionOrdersCreateMode *_closeAndNew;
}

- (instancetype)init
{
    if (self = [super init]) {
        _onlyClose = [OnlyCloseExecutionOrdersCreateMode new];
        _onlyNew = [OnlyNewExecutionOrdersCreateMode new];
        _closeAndNew = [CloseAndNewExecutionOrdersCreateMode new];
    }
    
    return self;
}

#warning positionsize
- (ExecutionOrdersCreateMode *)createModeFromOrder:(Order *)order
{
    PositionType *positionType = [OpenPosition positionTypeOfCurrencyPair:order.currencyPair];
    position_size_t totalPositionSize = [OpenPosition totalPositionSizeOfCurrencyPair:order.currencyPair].sizeValue;
    
    if (totalPositionSize == 0) {
        return _onlyNew;
    } else if ([positionType isEqualOrderType:order.positionType]) {
        return _onlyNew;
    } else {
        if (order.positionSize.sizeValue <= totalPositionSize) {
            return _onlyClose;
        } else if (totalPositionSize < order.positionSize.sizeValue) {
            return _closeAndNew;
        }
    }
    
    return nil;
}

@end
