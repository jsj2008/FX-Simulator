//
//  ExecutionHistoryRecord.m
//  FX Simulator
//
//  Created  on 2014/12/11.
//  
//

#import "ExecutionHistoryRecord.h"

#import "FMResultSet.h"
#import "CurrencyPair.h"
#import "Rate.h"
#import "MarketTime.h"
#import "Spread.h"
#import "OrderType.h"
#import "PositionSize.h"
#import "ProfitAndLossCalculator.h"

@implementation ExecutionHistoryRecord

-(id)initWithFMResultSet:(FMResultSet *)rs
{
    if (self = [super init]) {
        _orderID = [NSNumber numberWithInt:[rs intForColumn:@"rowid"]];
        _isClose = [rs boolForColumn:@"is_close"];
        _currencyPair = [[CurrencyPair alloc] initWithCurrencyPairString:[rs stringForColumn:@"currency_pair"]];
        _usersOrderNumber = [NSNumber numberWithInt:[rs intForColumn:@"users_order_number"]];
        //_ratesId = [NSNumber numberWithInt:[rs intForColumn:@"currency_data_id"]];
        MarketTime *orderRateTimestamp = [[MarketTime alloc] initWithTimestamp:[rs intForColumn:@"order_rate_timestamp"]];
        _orderRate = [[Rate alloc] initWithRateValue:[rs doubleForColumn:@"order_rate"] currencyPair:_currencyPair timestamp:orderRateTimestamp];
        _orderSpread = [[Spread alloc] initWithPips:[rs doubleForColumn:@"order_spread"] currencyPair:_currencyPair];
        _orderType = [[OrderType alloc] initWithString:[rs stringForColumn:@"order_type"]];
        _positionSize = [[PositionSize alloc] initWithSizeValue:[rs intForColumn:@"position_size"]];
        
        if (_isClose) {
            _closeUsersOrderNumber = [NSNumber numberWithInt:[rs intForColumn:@"close_order_number"]];
            _closeOrderRate = [[Rate alloc] initWithRateValue:[rs doubleForColumn:@"close_order_rate"] currencyPair:_currencyPair timestamp:nil];
            _closeOrderSpread = [[Spread alloc] initWithPips:[rs doubleForColumn:@"close_order_spread"] currencyPair:_currencyPair];
        }
    }
    
    return self;
}

-(Money*)profitAndLoss
{
    if (self.isClose) {
        return [ProfitAndLossCalculator calculateByTargetRate:self.orderRate valuationRate:self.closeOrderRate positionSize:self.positionSize orderType:self.orderType];
    } else {
        return nil;
    }
}

@end
