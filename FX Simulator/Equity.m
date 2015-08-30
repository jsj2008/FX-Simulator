//
//  Equity.m
//  FX Simulator
//
//  Created  on 2014/12/17.
//  
//

#import "Equity.h"

#import "Currency.h"
#import "ForexHistoryData.h"
#import "Money.h"
#import "Balance.h"

@interface Equity ()
@property (nonatomic, readwrite) Money *equity;
@end

@implementation Equity {
    Money *_profitAndLoss;
    Balance *_balance;
}

- (instancetype)initWithBalance:(Balance *)balance
{
    if (self = [super init]) {
        _balance = balance;
    }
    
    return self;
}

- (void)setCurrentProfitAndLoss:(Money *)profitAndLoss
{
    _profitAndLoss = profitAndLoss;
}

- (Money *)equity
{
    return [_balance.balance addMoney:_profitAndLoss];
}

- (BOOL)isShortage
{
    if (self.equity.amount < 0) {
        return YES;
    } else {
        return NO;
    }
}

@end
