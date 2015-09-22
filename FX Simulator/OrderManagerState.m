//
//  OrderManagerState.m
//  FXSimulator
//
//  Created by yuu on 2015/09/07.
//
//

#import "OrderManagerState.h"

#import "OpenPositionRelationChunk.h"
#import "Order.h"
#import "OrderResult.h"

@implementation OrderManagerState {
    NSHashTable *_states;
    OpenPositionRelationChunk *_openPositions;
}

- (instancetype)init
{
    return nil;
}

- (instancetype)initWithOpenPositions:(OpenPositionRelationChunk *)openPositions
{
    if (self = [super init]) {
        _states = [NSHashTable weakObjectsHashTable];
        _openPositions = openPositions;
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
            __block BOOL isSuccess;
            [result completion:^{
                isSuccess = YES;
            } error:^{
                isSuccess = NO;
            }];
            if (!isSuccess) {
                return result;
            }
        }
    }
    
    if (![_openPositions isExecutableNewPosition] && order.isNew) {
        return [[OrderResult alloc] initWithIsSuccess:NO title:@"Max Open Position" message:nil];
    }
    
    return [[OrderResult alloc] initWithIsSuccess:YES title:nil message:nil];
}

@end
