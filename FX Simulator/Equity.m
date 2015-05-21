//
//  Equity.m
//  FX Simulator
//
//  Created  on 2014/12/17.
//  
//

#import "Equity.h"

#import "Currency.h"
#import "Money.h"
#import "Balance.h"

@implementation Equity {
    //Currency *_currency;
    Money *_profitAndLoss;
    Balance *_balance;
}

-(id)initWithBalance:(Balance*)balance
{
    if (self = [super init]) {
        _balance = balance;
        //_currency = _balance.currency;
    }
    
    return self;
}

-(void)updateBalance
{
    [_balance updateBalance];
}

-(void)setCurrentProfitAndLoss:(Money*)profitAndLoss
{
    _profitAndLoss = profitAndLoss;
}

-(Money*)equity
{
    return [_balance.balance addMoney:_profitAndLoss];
}

@end
