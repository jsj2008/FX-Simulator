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
#import "OrderResult.h"
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

- (void)notifyDidOrder:(OrderResult *)result
{
    for (id<OrderManagerDelegate> delegate in _delegates) {
        if ([delegate respondsToSelector:@selector(didOrder:)]) {
            [delegate didOrder:result];
        }
    }
}

- (void)order:(Order *)order
{
    OrderResult *result = [_state isOrderable:order];
    
    [result completion:^{
        [self execute:[order createExecutionOrders]];
    } error:^{
        [self notifyDidOrder:result];
    }];
}

- (void)execute:(NSArray<ExecutionOrder *> *)executionOrders
{    
    OrderResult *result;
    
    @try {
        
        if (!executionOrders.count) {
            [NSException raise:@"OrderException" format:@"create Execution Orders failed"];
        }
        
        [TradeDatabase transaction:^{
            for (ExecutionOrder *order in executionOrders) {
                [order execute];
            }
        }];
        
        result = [[OrderResult alloc] initWithIsSuccess:YES title:nil message:nil];
        
    }
    @catch (NSException *exception) {
        
        result = [[OrderResult alloc] initWithIsSuccess:NO title:exception.name message:exception.reason];
        
    }
    @finally {
        
        [self notifyDidOrder:result];
        
    }
}

@end
