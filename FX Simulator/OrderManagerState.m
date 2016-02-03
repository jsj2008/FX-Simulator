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
#import "Result.h"
#import "PositionType.h"

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

- (Result *)isOrderable:(Order *)order
{
    for (id<OrderManagerState> state in _states) {
        if ([state respondsToSelector:@selector(isOrderable:)]) {
            Result *result = [state isOrderable:order];
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
    
    if (![_openPositions isExecutableNewPosition] && [[_openPositions positionTypeOfCurrencyPair:order.currencyPair] isEqualPositionType:order.positionType]) {
        return [[Result alloc] initWithIsSuccess:NO title:@"Max Open Position" message:nil];
    }
    
    return [[Result alloc] initWithIsSuccess:YES title:nil message:nil];
}

@end
