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

@implementation Money

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
    if (self.currency == nil) {
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
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setGroupingSeparator:@","];
    [formatter setGroupingSize:3];
    
    //NSString *result = [formatter stringFromNumber:priceNumber];
    
    return [formatter stringFromNumber:self.toMoneyValueObj];
    //return [NSString stringWithFormat:@"%lli", _amount];
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
