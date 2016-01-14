//
//  OrderFactory.m
//  FXSimulator
//
//  Created by yuu on 2016/01/14.
//
//

#import "OrderFactory.h"

#import "NormalizedOrdersFactory.h"
#import "Order.h"

@implementation OrderFactory {
    NSUInteger _saveSlot;
    NormalizedOrdersFactory *_normalizedOrdersFactory;
}

- (instancetype)initWithSaveSlot:(NSUInteger)slot openPositions:(OpenPositionRelationChunk *)openPositions
{
    if (!openPositions) {
        return nil;
    }
    
    if (self = [super init]) {
        _saveSlot = slot;
        _normalizedOrdersFactory = [[NormalizedOrdersFactory alloc] initWithOpenPositions:openPositions];
    }
    
    return self;
}

- (Order *)orderWithCurrencyPair:(CurrencyPair *)currencyPair positionType:(PositionType *)positionType rate:(Rate *)rate positionSize:(PositionSize *)positionSize
{
    return [[Order alloc] initWithSaveSlot:_saveSlot CurrencyPair:currencyPair positionType:positionType rate:rate positionSize:positionSize normalizedOrdersFactory:_normalizedOrdersFactory];
}

@end
