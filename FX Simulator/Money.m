//
//  Money.m
//  FX Simulator
//
//  Created  on 2014/12/04.
//  
//

#import "Money.h"

#import "CurrencyConverter.h"
#import "Currency.h"
#import "NSNumber+FXSNumberConverter.h"

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

// NewStartの新しいSaveData作成のところでは、currencyにnil入れている。
-(id)initWithAmount:(amount_t)amount currency:(Currency*)currency
{
    if (self = [super init]){
        _amount = amount;
        _currency = currency;
    }
    
    return self;
}

-(Money*)addMoney:(Money*)money
{
    if (self.currency == nil || money == nil) {
        DLog(@"Currency or Money nil");
        return nil;
    }
    
    if ([self.currency isEqualCurrency:money.currency] || money == nil) {
        return [[Money alloc] initWithAmount:(self.amount + money.amount) currency:self.currency];
    } else {
        return nil;
    }
}

-(Money*)convertToCurrency:(Currency*)currency
{
    if (self.currency == nil) {
        return nil;
    }
    
    return [CurrencyConverter convert:self to:currency];
}

-(NSNumber*)toMoneyValueObj
{
    return [NSNumber numberWithLongLong:_amount];
}

-(NSString*)toDisplayString
{
    return [self.toMoneyValueObj fxs_toDisplayString];
}

-(UIColor*)toDisplayColor
{
    if (0 <= _amount) {
        return [UIColor whiteColor];
    } else {
        return [UIColor redColor];
    }
}

@end
