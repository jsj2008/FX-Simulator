//
//  OrderManager.m
//  FXSimulator
//
//  Created by yuu on 2015/09/05.
//
//

#import "OrderManager.h"

#import "ExecutionOrder.h"
#import "NormalizedOrdersFactory.h"
#import "Order.h"
#import "OrderManagerState.h"
#import "Result.h"
#import "TradeDatabase.h"

@implementation OrderManager {
    NSHashTable *_delegates;
    OrderManagerState *_state;
    NormalizedOrdersFactory *_normalizedOrdersFactory;
}

+ (instancetype)createOrderManagerFromOpenPositions:(OpenPositionRelationChunk *)openPositions
{
    return [[[self class] alloc] initWithOrderManagerState:[[OrderManagerState alloc] initWithOpenPositions:openPositions] openPositions:openPositions];
}

- (instancetype)initWithOrderManagerState:(OrderManagerState *)state openPositions:(OpenPositionRelationChunk *)openPositions
{
    if (self = [super init]) {
        _delegates = [NSHashTable weakObjectsHashTable];
        _state = state;
        _normalizedOrdersFactory = [[NormalizedOrdersFactory alloc] initWithOpenPositions:openPositions];
    }
    
    return self;
}

- (void)addDelegate:(id<OrderManagerDelegate>)delegate
{
    [_delegates addObject:delegate];
}

- (void)addState:(id<OrderManagerState>)state
{
    [_state addState:state];
}

- (void)notifyDidOrder:(Result *)result
{
    for (id<OrderManagerDelegate> delegate in _delegates) {
        if ([delegate respondsToSelector:@selector(didOrder:)]) {
            [delegate didOrder:result];
        }
    }
}

- (void)order:(Order *)order
{
    Result *result = [_state isOrderable:order];
    
    [result success:^{
        [self execute:[order createExecutionOrders]];
    } failure:^{
        [self notifyDidOrder:result];
    }];
}

- (void)execute:(NSArray<ExecutionOrder *> *)executionOrders
{
    Result *failedOrder = [[Result alloc] initWithIsSuccess:NO title:NSLocalizedString(@"Order Failed", nil) message:NSLocalizedString(@"Execute Failed", nil)];
    
    if (!executionOrders.count) {
        [self notifyDidOrder:failedOrder];
        return;
    }
    
    __block Result *result;
        
    [TradeDatabase transaction:^{
        for (ExecutionOrder *order in executionOrders) {
                [order execute];
        }
    } completion:^(BOOL isRollbacked) {
        if (isRollbacked) {
            result = failedOrder;
        } else {
            result = [[Result alloc] initWithIsSuccess:YES title:nil message:nil];
        }
    }];
        
    [self notifyDidOrder:result];
}

@end
