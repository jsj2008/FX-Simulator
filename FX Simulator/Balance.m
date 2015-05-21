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
#import "ExecutionHistoryRecord.h"
#import "CurrencyConverter.h"
#import "ProfitAndLossCalculator.h"

@implementation Balance {
    Money *_startBalance;
    ExecutionHistory *_executionHistory;
    NSArray *_executionHistoryRecords;
}

-(id)initWithStartBalance:(Money*)balance ExecutionHistory:(ExecutionHistory*)executionHistory
{
    if (self = [super init]) {
        _currency = balance.currency;
        _balance = balance;
        _startBalance = balance;
        _executionHistory = executionHistory;
        //_executionHistoryRecords = [_executionHistory all];
        [self updateBalance];
    }
    
    return self;
}

-(void)updateBalance
{
    _executionHistoryRecords = [_executionHistory all];
    
    _balance = [self calculateBalance];
}

-(Money*)calculateBalance
{
    /*BOOL existCloseRecord = NO;
    
    for (ExecutionHistoryRecord *record in _executionHistoryRecords) {
        if (record.isClose) {
            existCloseRecord = YES;
            break;
        }
    }*/
    
    amount_t balance = 0;
    
    for (ExecutionHistoryRecord *record in _executionHistoryRecords) {
        if (record.isClose) {
            Money *profitAndLoss = [ProfitAndLossCalculator calculateByTargetRate:record.orderRate valuationRate:record.closeOrderRate positionSize:record.positionSize orderType:record.orderType];
            Money *convertedProfitAndLoss = [CurrencyConverter convert:profitAndLoss to:_startBalance.currency];
            balance += convertedProfitAndLoss.amount;
        }
    }
    
    balance += _startBalance.amount;
    
    //Currency *currency = ((ExecutionHistoryRecord*)[_executionHistoryRecords firstObject]).currencyPair.baseCurrency;
    
    return [[Money alloc] initWithAmount:balance currency:_startBalance.currency];
}

@end
