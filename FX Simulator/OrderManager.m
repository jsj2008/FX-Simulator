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
}

+ (instancetype)createOrderManager
{
    return [[[self class] alloc] initWithOrderManagerState:[OrderManagerState new]];
}

- (instancetype)initWithOrderManagerState:(OrderManagerState *)state
{
    if (self = [super init]) {
        _delegates = [NSHashTable weakObjectsHashTable];
        _state = state;
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
    
    if (!result.isSuccess) {
        [self notifyDidOrder:result];
        return;
    }
    
    NSArray *normalizedOrders = [NormalizedOrdersFactory createNormalizedOrdersFromOrder:order];
    
    [normalizedOrders enumerateObjectsUsingBlock:^(Order *normalizedOrder, NSUInteger idx, BOOL *stop) {
        [self execute:normalizedOrder];
    }];
}

- (void)execute:(Order *)order
{
    NSArray *executionOrders = [order createExecutionOrders];
    
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
