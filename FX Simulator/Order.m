//
//  Order.m
//  FX Simulator
//
//  Created  on 2014/11/23.
//  
//

#import "Order.h"

@implementation Order

-(id)initWithCurrencyPair:(CurrencyPair *)currencyPair orderType:(OrderType *)orderType orderRate:(Rate *)orderRate positionSize:(PositionSize *)positionSize orderSpread:(Spread *)spread
{
    if (self = [super init]) {
        _currencyPair = currencyPair;
        _orderType = orderType;
        _orderRate = orderRate;
        _positionSize = positionSize;
        _orderSpread = spread;
    }
    
    return self;
}

@end
