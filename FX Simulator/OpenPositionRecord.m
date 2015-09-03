//
//  OpenPositionRecord.m
//  FX Simulator
//
//  Created  on 2014/07/15.
//  
//

#import "OpenPositionRecord.h"

#import "ProfitAndLossCalculator.h"
#import "CurrencyConverter.h"
#import "FMDatabase.h"
#import "ForexHistoryData.h"
#import "Market.h"
#import "Rate.h"
#import "Rates.h"
#import "OrderHistory.h"
#import "PositionType.h"
#import "PositionSize.h"
#import "Spread.h"
#import "OpenPositionRawRecord.h"
#import "ExecutionHistoryRecord.h"

@implementation OpenPositionRecord

/*- (instancetype)initWithNewExecutionOrder:(ExecutionOrder *)order
{
    if (self = [super init]) {
        _executionOrderID = order.orderID;
        _usersOrderNumber = [NSNumber numberWithInt:order.usersOrderNumber];
        _currencyPair = order.currencyPair;
        //_ratesId = order.forexHistoryData.ratesID;
        _orderRate = order.orderRate;
        _orderSpread = order.orderSpread;
        _orderType = order.orderType;
        _positionSize = order.positionSize;
        _isAllPositionSize = YES;
    }
    
    return self;
}*/

/*-(id)initWithFMResultSet:(FMResultSet *)rs currencyPair:(CurrencyPair *)currencyPair
{
    if (self = [super init]) {
        _openPositionNumber = [rs intForColumn:@"id"];
        _orderNumber = [rs intForColumn:@"users_order_number"];
        _ratesId = [rs intForColumn:@"currency_data_id"];
        _orderRate = [[Rate alloc] initWithRateValue:[rs doubleForColumn:@"order_rate"] currencyPair:currencyPair];
        _orderSpread = [[Spread alloc] initWithPips:[rs doubleForColumn:@"order_spread"] currencyPair:currencyPair];
        _orderType = [[OrderType alloc] initWithString:[rs stringForColumn:@"trade_type"]];
        _positionSize = [[PositionSize alloc] initWithSizeValue:[rs intForColumn:@"position_size"]];
        _isAllPositionSize = YES;
    }
    
    return self;
}*/

- (instancetype)initWithFMResultSet:(FMResultSet *)result orderHistory:(OrderHistory *)orderHistory
{
    NSUInteger orderHistoryId = [result intForColumn:@"order_history_id"];
    
    Order *order = [orderHistory getOrderFromOrderHistoryId:orderHistoryId];
    
    if (!order) {
        return nil;
    }
    
    PositionSize *openPositionSize = [[PositionSize alloc] initWithSizeValue:[result intForColumn:@"open_position_size"]];
    
    if (self = [super initWithOrderHistoryId:order.orderHistoryId CurrencyPair:order.currencyPair orderType:order.orderType orderRate:order.orderRate positionSize:openPositionSize orderSpread:order.orderSpread]) {
        _openPositionId = [result intForColumn:@"id"];
        _executionHistoryId = [result intForColumn:@"execution_history_id"];
    }
    
    return self;
}

/*-(id)initWithOpenPositionRawRecord:(OpenPositionRawRecord*)rawRecord executionHistoryRecord:(ExecutionHistoryRecord*)record
{
    if (![rawRecord.executionOrderID isEqualToNumber:record.orderID]) {
        return nil;
    }
    
    if (self = [super init]) {
        _openPositionNumber = [rawRecord.recordID intValue];
        _executionOrderID = [rawRecord.executionOrderID intValue];
        _usersOrderNumber = record.usersOrderNumber;
        _currencyPair = record.currencyPair;
        //_ratesId = [record.ratesId intValue];
        _orderRate = record.orderRate;
        _orderSpread = record.orderSpread;
        _orderType = record.orderType;
        _positionSize = rawRecord.positionSize;
        // OpenPositionが全てのポジションサイズがあるか、それとも一部がCloseされて、一部しかないか
        if ([rawRecord.positionSize isEqualPositionSize:record.positionSize]) {
            _isAllPositionSize = YES;
        } else {
            _isAllPositionSize = NO;
        }
    }
    
    return self;
}*/

- (Money *)profitAndLossForMarket:(Market *)market
{
    Rates *valuationRates = [market getCurrentRatesOfCurrencyPair:self.currencyPair];
    
    Rate *valuationRate;
    
    if ([self.orderType isShort]) {
        valuationRate = valuationRates.askRate;
    } else if ([self.orderType isLong]) {
        valuationRate = valuationRates.bidRate;
    } else {
        return nil;
    }
    
    Money *profitAndLoss = [ProfitAndLossCalculator calculateByTargetRate:self.orderRate valuationRate:valuationRate positionSize:self.positionSize orderType:self.orderType];
    
    return profitAndLoss;
}

@end
