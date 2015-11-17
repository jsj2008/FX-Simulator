//
//  Money.m
//  FX Simulator
//
//  Created  on 2014/12/04.
//  
//

#import "Money.h"

#import "Currency.h"
#import "CurrencyConverter.h"
#import "CurrencyPair.h"
#import "FXSComparisonResult.h"
#import "NSNumber+FXSNumberConverter.h"
#import "Rate.h"
#import "Setting.h"

static NSString* const FXSMoneyValueKey = @"moneyValue";
static NSString* const FXSCurrencyKey = @"currency";

@implementation Money

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    return [self initWithAmount:[aDecoder decodeInt64ForKey:FXSMoneyValueKey] currency:[aDecoder decodeObjectForKey:FXSCurrencyKey]];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInt64:self.amount forKey:FXSMoneyValueKey];
    [aCoder encodeObject:self.currency forKey:FXSCurrencyKey];
}

- (instancetype)init
{
    return nil;
}

- (instancetype )initWithAmount:(amount_t)amount currency:(Currency *)currency
{
    if (!currency) {
        return nil;
    }
    
    if (self = [super init]){
        _amount = amount;
        _currency = currency;
    }
    
    return self;
}

- (instancetype)initWithNumber:(NSNumber *)number currency:(Currency*)currency
{
    return [self initWithAmount:number.longLongValue currency:currency];
}

- (instancetype)initWithString:(NSString *)string currency:(Currency*)currency
{
    return [self initWithAmount:string.longLongValue currency:currency];
}

- (Money *)addMoney:(Money *)money
{
    if (money == nil) {
        DLog(@"money is nil");
        return self;
    }
    
    if ([self.currency isEqualCurrency:money.currency]) {
        return [[Money alloc] initWithAmount:(self.amount + money.amount) currency:self.currency];
    } else {
        DLog(@"different currency");
        return self;
    }
}

- (FXSComparisonResult *)compareMoney:(Money *)money
{
    if (![self.currency isEqualCurrency:money.currency]) {
        return nil;
    }
    
    return [[FXSComparisonResult alloc] initWithComparisonResult:[self.toMoneyValueObj compare:money.toMoneyValueObj]];
}

- (Money *)convertToCurrency:(Currency *)currency
{
    return [CurrencyConverter convert:self to:currency];
}

- (NSNumber *)toMoneyValueObj
{
    return [NSNumber numberWithLongLong:_amount];
}

- (NSString *)toDisplayString
{
    return [self.toMoneyValueObj fxs_toDisplayString];
}

- (UIColor *)toDisplayColor
{
    if (0 <= _amount) {
        return [UIColor whiteColor];
    } else {
        return [UIColor redColor];
    }
}

@end
