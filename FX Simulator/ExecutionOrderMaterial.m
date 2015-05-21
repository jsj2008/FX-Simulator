//
//  OrderForExecution.m
//  FX Simulator
//
//  Created  on 2014/11/22.
//  
//

#import "ExecutionOrderMaterial.h"

#import "Order.h"

@implementation ExecutionOrderMaterial

@synthesize usersOrderNumber = _usersOrderNumber;

-(id)init
{
    return nil;
}

-(id)initWithCurrencyPair:(CurrencyPair *)currencyPair orderType:(OrderType *)orderType orderRate:(Rate *)orderRate positionSize:(PositionSize *)positionSize orderSpread:(Spread *)spread
{
    return nil;
}

-(id)initWithOrder:(Order *)order usersOrderNumber:(int)number
{
    if (self = [super initWithCurrencyPair:order.currencyPair orderType:order.orderType orderRate:order.orderRate positionSize:order.positionSize orderSpread:order.orderSpread]) {
        _usersOrderNumber = number;
    }
    
    return self;
}

@end
