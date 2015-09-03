//
//  Balance.m
//  FX Simulator
//
//  Created  on 2014/12/17.
//  
//

#import "Balance.h"

#import "Common.h"
#import "CurrencyPair.h"
#import "Money.h"
#import "ExecutionHistory.h"
#import "ExecutionOrder.h"
#import "CurrencyConverter.h"
#import "ProfitAndLossCalculator.h"
#import "SaveData.h"
#import "SaveLoader.h"

@implementation Balance {
    Money *_startBalance;
    NSArray *_executionHistoryRecords;
}

- (instancetype)initWithStartBalance:(Money *)balance
{
    if (self = [super init]) {
        _startBalance = balance;
    }
    
    return self;
}

- (Money *)calculateBalance
{
    /*_executionHistoryRecords = [_executionHistory all];
    
    amount_t balance = 0;
    
    for (ExecutionOrder *record in _executionHistoryRecords) {
        if (record.isClose) {
            Money *profitAndLoss = record.profitAndLoss;
            Money *convertedProfitAndLoss = [CurrencyConverter convert:profitAndLoss to:_startBalance.currency];
            balance += convertedProfitAndLoss.amount;
        }
    }
    
    balance += _startBalance.amount;*/
    
    Money *profitAndLoss = [ExecutionOrder profitAndLossOfCurrencyPair:];
    
    return [[Money alloc] initWithAmount:balance currency:_startBalance.currency];
}

- (Money *)balanceInCurrency:(Currency *)currency
{
    return [[self calculateBalance] convertToCurrency:currency];
}

@end
