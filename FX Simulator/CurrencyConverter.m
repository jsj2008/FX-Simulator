//
//  CurrencyConverter.m
//  FX Simulator
//
//  Created  on 2014/12/04.
//  
//

#import "CurrencyConverter.h"
#import "CurrencyPair.h"
#import "Money.h"
#import "Currency.h"
#import "Common.h"
#import "Setting.h"
#import "Rate.h"

@implementation CurrencyConverter

+(Money*)convert:(Money*)money to:(Currency*)currency
{
    if ([money.currency isEqualCurrency:currency]) {
        return money;
    }
    
    CurrencyPair *currencyPair = [[CurrencyPair alloc] initWithBaseCurrency:money.currency QuoteCurrency:currency];
    
    Rate *baseRate = [Setting baseRateOfCurrencyPair:currencyPair];
    
    //[money.amount unsignedLongLongValue] * [baseRate doubleValue];
    
    amount_t amount = money.amount * baseRate.rateValue;
    
    return [[Money alloc] initWithAmount:amount currency:currency];
}

@end
