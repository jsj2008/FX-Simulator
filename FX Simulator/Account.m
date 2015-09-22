//
//  Account.m
//  FX Simulator
//
//  Created by yuu on 2015/06/15.
//
//

#import "Account.h"

#import "ExecutionOrder.h"
#import "ExecutionOrderRelationChunk.h"
#import "ForexHistoryData.h"
#import "Lot.h"
#import "Market.h"
#import "Money.h"
#import "Money+ConvertToAccountCurrency.h"
#import "OpenPosition.h"
#import "OpenPositionRelationChunk.h"
#import "PositionSize.h"
#import "PositionType.h"
#import "Rate.h"
#import "SaveData.h"
#import "SaveLoader.h"
#import "SimulationManager.h"

@implementation Account {
    Currency *_accountCurrency;
    CurrencyPair *_currencyPair;
    Money *_startBalance;
    OpenPositionRelationChunk *_openPositions;
    ExecutionOrderRelationChunk *_executionOrders;
}

-(instancetype)initWithAccountCurrency:(Currency *)currency currencyPair:(CurrencyPair *)currencyPair startBalance:(Money *)balance openPositions:(OpenPositionRelationChunk *)openPositions executionOrders:(ExecutionOrderRelationChunk *)executionOrders
{
    if (self = [super init]) {
        _accountCurrency = currency;
        _currencyPair = currencyPair;
        _startBalance = balance;
        _openPositions = openPositions;
        _executionOrders = executionOrders;
    }
    
    return self;
}

- (BOOL)isShortageForMarket:(Market *)market
{
    Money *equity = [self equityForMarket:market];
    
    if (equity.amount <= 0) {
        return YES;
    } else {
        return NO;
    }
}

- (void)displayDataUsingBlock:(void (^)(NSString *equityStringValue, NSString *profitAndLossStringValue, NSString *orderTypeStringValue, NSString *averageRateStringValue, NSString *totalLotStringValue, UIColor *equityStringColor, UIColor *profitAndLossStringColor))block market:(Market *)market positionSizeOfLot:(PositionSize *)positionSize
{
    if (!block || !market) {
        return;
    }
    
    Money *equity = [self equityForMarket:market];
    Money *profitAndLoss = [self profitAndLossForMarket:market];
    
    block(equity.toDisplayString, profitAndLoss.toDisplayString, [self orderType].toDisplayString, [self averageRate].toDisplayString, [[self totalPositionSize] toLotFromPositionSizeOfLot:positionSize].toDisplayString, equity.toDisplayColor, profitAndLoss.toDisplayColor);
}

- (Rate *)averageRate
{
    return [_openPositions averageRateOfCurrencyPair:_currencyPair];
}

- (Money *)balance
{
    Money *profitAndLoss = [[_executionOrders profitAndLossOfCurrencyPair:_currencyPair] convertToCurrency:_accountCurrency];
    
    return [_startBalance addMoney:profitAndLoss];
}

- (Money *)equityForMarket:(Market *)market
{
    Money *profitAndLoss = [self profitAndLossForMarket:market];
    
    return [self.balance addMoney:profitAndLoss];
}

- (PositionType *)orderType
{
    return [_openPositions positionTypeOfCurrencyPair:_currencyPair];
}

- (Money *)profitAndLossForMarket:(Market *)market
{    
    return [_openPositions profitAndLossOfCurrencyPair:_currencyPair ForMarket:market InCurrency:_accountCurrency];
}

- (PositionSize *)totalPositionSize
{
    return [_openPositions totalPositionSizeOfCurrencyPair:_currencyPair];
}

@end
