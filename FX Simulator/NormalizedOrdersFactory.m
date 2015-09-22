//
//  NormalizedOrdersFactory.m
//  FXSimulator
//
//  Created by yuu on 2015/09/05.
//
//

#import "NormalizedOrdersFactory.h"

#import "OrdersCreateMode.h"
#import "OrdersCreateModeFactory.h"

@implementation NormalizedOrdersFactory {
    OrdersCreateModeFactory *_ordersCreateModeFactory;
}

- (instancetype)init
{
    return nil;
}

- (instancetype)initWithOpenPositions:(OpenPositionRelationChunk *)openPositions
{
    if (!openPositions) {
        return nil;
    }
    
    if (self = [super init]) {
        _ordersCreateModeFactory = [[OrdersCreateModeFactory alloc] initWithOpenPositions:openPositions];
    }
    
    return self;
}

- (NSArray *)createNormalizedOrdersFromOrder:(Order *)order
{
    OrdersCreateMode *createMode = [_ordersCreateModeFactory createModeFromOrder:order];
    
    return [createMode create:order];
}

@end
