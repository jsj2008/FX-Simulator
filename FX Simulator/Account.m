//
//  Account.m
//  FX Simulator
//
//  Created by yuu on 2015/06/15.
//
//

#import "Account.h"

#import "Balance.h"
#import "ExecutionOrder.h"
#import "ForexHistoryData.h"
#import "Lot.h"
#import "Market.h"
#import "Money.h"
#import "Money+ConvertToAccountCurrency.h"
#import "OpenPosition.h"
#import "SaveData.h"
#import "SaveLoader.h"
#import "SimulationManager.h"

@implementation Account {
    Currency *_accountCurrency;
    CurrencyPair *_currencyPair;
    Money *_startBalance;
}

-(instancetype)initWithAccountCurrency:(Currency *)currency currencyPair:(CurrencyPair *)currencyPair startBalance:(Money *)balance
{
    if (self = [super init]) {
        _accountCurrency = currency;
        _currencyPair = currencyPair;
        _startBalance = balance;
    }
    
    return self;
}

- (BOOL)isShortage
{
    if (self.equity.amount <= 0) {
        return YES;
    } else {
        return NO;
    }
}

- (Rate *)averageRate
{
    return [OpenPosition averageRateOfCurrencyPair:_currencyPair];
}

- (Money *)balance
{
    Money *profitAndLoss = [[ExecutionOrder profitAndLossOfCurrencyPair:_currencyPair] convertToCurrency:_accountCurrency];
    
    return [_startBalance addMoney:profitAndLoss];
}

- (Money *)equity
{
    return [self.balance addMoney:self.profitAndLoss];
}

- (PositionType *)orderType
{
    return [OpenPosition positionTypeOfCurrencyPair:_currencyPair];
}

- (Money *)profitAndLoss
{
    Market *market = [SimulationManager sharedSimulationManager].market;
    
    return [OpenPosition profitAndLossOfCurrencyPair:_currencyPair ForMarket:market InCurrency:_accountCurrency];
}

- (Lot *)totalLot
{
    return [OpenPosition totalLotOfCurrencyPair:_currencyPair];
}

@end
