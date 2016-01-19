//
//  ExecutionOrderRelationChunk.m
//  FXSimulator
//
//  Created by yuu on 2015/09/20.
//
//

#import "ExecutionOrderRelationChunk.h"

#import "ExecutionOrder.h"

@implementation ExecutionOrderRelationChunk {
    NSUInteger _saveSlot;
}

- (instancetype)initWithSaveSlot:(NSUInteger)slot
{
    if (self = [super init]) {
        _saveSlot = slot;
    }
    
    return self;
}

- (void)executionOrderDetail:(void (^)(CurrencyPair *currencyPair, PositionType *positionType, Rate *rate, NSUInteger orderId))block fromExecutionOrderId:(NSUInteger)executionOrderId
{
    if (!block) {
        return;
    }
    
    [ExecutionOrder executionOrderDetail:^(CurrencyPair *currencyPair, PositionType *positionType, Rate *rate, NSUInteger orderId) {
        block(currencyPair, positionType, rate, orderId);
    } fromExecutionOrderId:executionOrderId saveSlot:_saveSlot];
}

- (ExecutionOrder *)newestCloseOrderOfCurrencyPair:(CurrencyPair *)currencyPair
{
    return [ExecutionOrder newestCloseOrderOfSaveSlot:_saveSlot currencyPair:currencyPair];
}

- (Money *)profitAndLossOfCurrencyPair:(CurrencyPair *)currencyPair
{
    return [ExecutionOrder profitAndLossOfSaveSlot:_saveSlot currencyPair:currencyPair];
}

- (Money *)profitAndLossOfCurrencyPair:(CurrencyPair *)currencyPair newerThan:(ExecutionOrder *)oldOrder
{
    return [ExecutionOrder profitAndLossOfSaveSlot:_saveSlot currencyPair:currencyPair newerThan:oldOrder];
}

- (NSArray *)selectNewestFirstLimit:(NSUInteger)limit
{
    return [ExecutionOrder selectNewestFirstLimit:limit saveSlot:_saveSlot];
}

- (void)delete
{
    [ExecutionOrder deleteSaveSlot:_saveSlot];
}

@end
