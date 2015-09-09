//
//  OrderManagerState.m
//  FXSimulator
//
//  Created by yuu on 2015/09/07.
//
//

#import "OrderManagerState.h"

#import "OpenPosition.h"
#import "Order.h"
#import "OrderResult.h"

@implementation OrderManagerState {
    NSHashTable *_states;
}

- (instancetype)init
{
    if (self = [super init]) {
        _states = [NSHashTable weakObjectsHashTable];
    }
    
    return self;
}

- (void)addState:(id<OrderManagerState>)state
{
    [_states addObject:state];
}

- (OrderResult *)isOrderable:(Order *)order
{
    for (id<OrderManagerState> state in _states) {
        if ([state respondsToSelector:@selector(isOrderable:)]) {
            OrderResult *result = [state isOrderable:order];
            if (!result.isSuccess) {
                return result;
            }
        }
    }
    
    if (![OpenPosition isExecutableNewPosition] && order.isNew) {
        return [[OrderResult alloc] initWithIsSuccess:NO title:@"Max Open Position" message:nil];
    }
    
    return [[OrderResult alloc] initWithIsSuccess:YES title:nil message:nil];
}

@end
