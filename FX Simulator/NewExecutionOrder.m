//
//  NewExecutionOrder.m
//  FX Simulator
//
//  Created  on 2014/11/22.
//  
//

#import "NewExecutionOrder.h"

#import "FMResultSet.h"
#import "ExecutionOrderMaterial.h"


@implementation NewExecutionOrder

@synthesize usersOrderNumber = _usersOrderNumber;

-(id)initWithExecutionOrderMaterial:(ExecutionOrderMaterial *)material
{
    if (self = [super initWithCurrencyPair:material.currencyPair orderType:material.orderType orderRate:material.orderRate positionSize:material.positionSize orderSpread:material.orderSpread]) {
        _usersOrderNumber = material.usersOrderNumber;
    }
    
    return self;
}

/*-(id)initWithFMResultSet:(FMResultSet *)rs
{
    //users_order_number INTEGER NOT NULL, currency_data_id INTEGER NOT NULL, order_rate REAL NOT NULL, order_spread REAL NOT NULL, trade_type TXT NOT NULL, position_size INTEGER NOT NULL, is_close BOOL NOT NULL, close_order_number INTEGER, close_order_rate REAL, close_order_spread REAL
    
    if ([rs boolForColumn:@"is_close"]) {
        return nil;
    }
    
    
    
    
    if (self = [self init]) {
        _ratesID = [rs intForColumn:@"rowid"];
        _currencyPair = currencyPair;
        _open = [[Rate alloc] initWithRateValue:[rs doubleForColumn:@"open"] currencyPair:currencyPair];
        _close = [[Rate alloc] initWithRateValue:[rs doubleForColumn:@"close"] currencyPair:currencyPair];
        _high = [[Rate alloc] initWithRateValue:[rs doubleForColumn:@"high"] currencyPair:currencyPair];
        _low = [[Rate alloc] initWithRateValue:[rs doubleForColumn:@"low"] currencyPair:currencyPair];
        _openTimestamp = [rs intForColumn:@"open_minute_open_timestamp"];
        _closeTimestamp = [rs intForColumn:@"close_minute_close_timestamp"];;
    }
    
    return self;
}*/

@end
