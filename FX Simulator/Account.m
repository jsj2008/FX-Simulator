//
//  Account.m
//  FX Simulator
//
//  Created by yuu on 2015/06/15.
//
//

#import "Account.h"

#import "Balance.h"
#import "Equity.h"
#import "EquityFactory.h"
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
    Balance *_balance;
    OpenPosition *_openPosition;
}

-(instancetype)initWithAccountCurrency:(Currency *)currency currencyPair:(CurrencyPair *)currencyPair balance:(Balance *)balance openPosition:(OpenPosition *)openPosition
{
    if (self = [super init]) {
        _accountCurrency = currency;
        _currencyPair = currencyPair;
        _balance = balance;
        _openPosition = openPosition;
    }
    
    return self;
}

- (void)updatedSaveData
{
    _balance = [Balance loadBalance];
    _openPosition = [OpenPosition loadOpenPosition];
}

- (void)didOrder
{
    [_openPosition update];
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
    return [_openPosition averageRateOfCurrencyPair:_currencyPair];
}

- (Money *)equity
{
    Money *balance = [_balance balanceInCurrency:_accountCurrency];
    Money *profitAndLoss = [self profitAndLoss];
    
    return [balance addMoney:profitAndLoss];
}

- (OrderType *)orderType
{
    return [_openPosition orderTypeOfCurrencyPair:_currencyPair];
}

- (Money *)profitAndLoss
{
    Market *market = [SimulationManager sharedSimulationManager].market;
    
    return [_openPosition profitAndLossForMarket:market currencyPair:_currencyPair InCurrency:_accountCurrency];
}

- (Lot *)totalLot
{
    return [_openPosition totalLotOfCurrencyPair:_currencyPair];
}

@end
