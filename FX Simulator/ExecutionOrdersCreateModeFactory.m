//
//  ExecutionOrdersCreateModeFactory.m
//  FX Simulator
//
//  Created  on 2014/11/22.
//  
//

#import "ExecutionOrdersCreateModeFactory.h"

#import "OpenPosition.h"
#import "ExecutionOrderMaterial.h"
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

/*-(id)init
{
    if (self = [super init]) {
        openPosition = [OpenPositionFactory createOpenPosition];
        onlyClose = [OnlyCloseExecutionOrdersCreateMode new];
        onlyNew = [OnlyNewExecutionOrdersCreateMode new];
        closeAndNew = [CloseAndNewExecutionOrdersCreateMode new];
    }
    
    return self;
}*/

-(id)init
{
    return nil;
}

-(id)initWithOpenPosition:(OpenPosition *)openPosition
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

-(ExecutionOrdersCreateMode*)createMode:(ExecutionOrderMaterial*)order
{
    [_openPosition update];
    
    OrderType *orderType = _openPosition.orderType;
    position_size_t totalPositionSize = _openPosition.totalPositionSize.sizeValue;
    
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
