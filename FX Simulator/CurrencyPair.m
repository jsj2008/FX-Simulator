//
//  CurrencyPair.m
//  ForexGame
//
//  Created  on 2014/06/25.
//  
//

#import "CurrencyPair.h"

#import "Setting.h"
#import "Currency.h"

static NSString* const FXSCurrencyPairKey = @"CurrencyPair";

@implementation CurrencyPair {
    Currency *_baseCurrency;
    Currency *_quoteCurrency;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    return [self initWithCurrencyPairString:[aDecoder decodeObjectForKey:FXSCurrencyPairKey]];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:[self toCodeString] forKey:FXSCurrencyPairKey];
}

-(id)initWithBaseCurrency:(Currency *)baseCurrency QuoteCurrency:(Currency *)quoteCurrency
{
    if (self = [super init]) {
        _baseCurrency = baseCurrency;
        _quoteCurrency = quoteCurrency;
        
        if (_baseCurrency == nil || _quoteCurrency == nil) {
            return nil;
        }
    }
    
    return self;
}

-(id)initWithCurrencyPairString:(NSString *)currencyPairString
{
    CurrencyPair *currencyPair = [[Setting currencyPairDictionaryList] objectForKey:currencyPairString];
    
    return currencyPair;
}

-(BOOL)isEqual:(id)other {
    if (other == self) {
        return YES;
    } else if ([other isKindOfClass:[self class]]) {
        if ([self isEqualCurrencyPair:other]) {
            return YES;
        }
    }
                
    return NO;
}

-(BOOL)isQuoteCurrencyEqualJPY
{
    if (JPY == _quoteCurrency.type) {
        return YES;
    } else {
        return NO;
    }
}

-(BOOL)isEqualCurrencyPair:(CurrencyPair *)currencyPair
{
    if (self.baseCurrency.type == currencyPair.baseCurrency.type && self.quoteCurrency.type == currencyPair.quoteCurrency.type) {
        return YES;
    } else {
        return NO;
    }
}

-(NSString*)toCodeString
{
    return [NSString stringWithFormat:@"%@%@", _baseCurrency.toCodeString, _quoteCurrency.toCodeString];
}

-(NSString*)toDisplayString
{
    return [NSString stringWithFormat:@"%@/%@", _baseCurrency.toCodeString, _quoteCurrency.toCodeString];
}

-(NSString*)toCodeReverseString
{
    return [NSString stringWithFormat:@"%@%@", _quoteCurrency.toCodeString, _baseCurrency.toCodeString];
}

-(NSArray*)toArray
{
    return @[_baseCurrency.toCodeString, _quoteCurrency.toCodeString];
}

@end
