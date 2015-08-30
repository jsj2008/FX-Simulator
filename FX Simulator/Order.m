//
//  Order.m
//  FX Simulator
//
//  Created  on 2014/11/23.
//  
//

#import "Order.h"

#import "FMResultSet.h"
#import "CurrencyPair.h"
#import "MarketTime.h"
#import "OpenPosition.h"
#import "OrderType.h"
#import "PositionSize.h"
#import "Rate.h"
#import "Spread.h"

@implementation Order

- (instancetype)initWithFMResultSet:(FMResultSet*)resultSet
{
    if (self = [super init]) {
        _orderHistoryId = [resultSet intForColumn:@"id"];
        _currencyPair = [[CurrencyPair alloc] initWithCurrencyPairString:[resultSet stringForColumn:@"code"]];
#warning fix
        MarketTime *orderRateTimestamp = [[MarketTime alloc] initWithTimestamp:[resultSet intForColumn:@"order_timestamp"]];
        _orderRate = [[Rate alloc] initWithRateValue:[resultSet doubleForColumn:@"order_bid_rate"] currencyPair:_currencyPair timestamp:orderRateTimestamp];
        _orderSpread = [[Spread alloc] initWithPips:[resultSet doubleForColumn:@"order_spread"] currencyPair:_currencyPair];
        _orderType = [[OrderType alloc] initWithString:[resultSet stringForColumn:@"order_type"]];
        _positionSize = [[PositionSize alloc] initWithSizeValue:[resultSet intForColumn:@"position_size"]];
    }
    
    return self;
}

- (instancetype)initWithOrderHistoryId:(NSUInteger)orderHistoryId CurrencyPair:(CurrencyPair *)currencyPair orderType:(OrderType *)orderType orderRate:(Rate *)orderRate positionSize:(PositionSize *)positionSize orderSpread:(Spread *)spread
{
    if (self = [super init]) {
        _orderHistoryId = orderHistoryId;
        _currencyPair = currencyPair;
        _orderType = orderType;
        _orderRate = orderRate;
        _positionSize = positionSize;
        _orderSpread = spread;
    }
    
    return self;
}

- (instancetype)copyOrder
{
    return [self initWithOrderHistoryId:self.orderHistoryId CurrencyPair:self.currencyPair orderType:self.orderType orderRate:self.orderRate positionSize:self.positionSize orderSpread:self.orderSpread];
}

- (BOOL)includeCloseOrder
{
    OpenPosition *openPosition = [OpenPosition loadOpenPosition];
    
    if ([self.orderType isEqualOrderType:[openPosition orderTypeOfCurrencyPair:self.currencyPair]]) {
        return NO;
    } else {
        return YES;
    }
}

@end
