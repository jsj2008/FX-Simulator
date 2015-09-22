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
#import "OpenPositionRelationChunk.h"
#import "Order.h"
#import "PositionSize.h"
#import "PositionType.h"

@implementation OrdersCreateModeFactory {
    OpenPositionRelationChunk *_openPositions;
    OnlyCloseOrdersCreateMode *_onlyClose;
    OnlyNewOrdersCreateMode *_onlyNew;
    CloseAndNewOrdersCreateMode *_closeAndNew;
}

- (instancetype)initWithOpenPositions:(OpenPositionRelationChunk *)openPositions
{
    if (self = [super init]) {
        _openPositions = openPositions;
        _onlyClose = [OnlyCloseOrdersCreateMode new];
        _onlyNew = [OnlyNewOrdersCreateMode new];
        _closeAndNew = [[CloseAndNewOrdersCreateMode alloc] initWithOpenPositions:_openPositions];
    }
    
    return self;
}

#warning positionsize
- (OrdersCreateMode *)createModeFromOrder:(Order *)order
{
    PositionType *positionType = [_openPositions positionTypeOfCurrencyPair:order.currencyPair];
    position_size_t totalPositionSize = [_openPositions totalPositionSizeOfCurrencyPair:order.currencyPair].sizeValue;
    
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
