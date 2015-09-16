//
//  CurrencyPair.m
//  ForexGame
//
//  Created  on 2014/06/25.
//  
//

#import "CurrencyPair.h"

#import "Currency.h"
#import "Setting.h"

static NSString* const FXSBaseCurrencyKey = @"baseCurrency";
static NSString* const FXSQuoteCurrencyKey = @"quoteCurrency";
//static NSString* const FXSCurrencyPairKey = @"currencyPair";

@implementation CurrencyPair

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    Currency *baseCurrency = [aDecoder decodeObjectForKey:FXSBaseCurrencyKey];
    Currency *quoteCurrency = [aDecoder decodeObjectForKey:FXSQuoteCurrencyKey];
    
    return [self initWithBaseCurrency:baseCurrency QuoteCurrency:quoteCurrency];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.baseCurrency forKey:FXSBaseCurrencyKey];
    [aCoder encodeObject:self.quoteCurrency forKey:FXSQuoteCurrencyKey];
    //[aCoder encodeObject:[self toCodeString] forKey:FXSCurrencyPairKey];
}

- (instancetype)initWithBaseCurrency:(Currency *)baseCurrency QuoteCurrency:(Currency *)quoteCurrency
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

- (instancetype)initWithBaseCurrencyType:(CurrencyType)baseCurrencyType quoteCurrencyType:(CurrencyType)quoteCurrencyType
{
    Currency *baseCurrency = [[Currency alloc] initWithCurrencyType:baseCurrencyType];
    Currency *quoteCurrency = [[Currency alloc] initWithCurrencyType:quoteCurrencyType];
    
    return [self initWithBaseCurrency:baseCurrency QuoteCurrency:quoteCurrency];
}

- (instancetype)initWithCurrencyPairString:(NSString *)currencyPairString
{
    CurrencyPair *currencyPair = [[Setting currencyPairDictionaryList] objectForKey:currencyPairString];
    
    return currencyPair;
}

- (BOOL)isEqual:(id)other {
    if (other == self) {
        return YES;
    } else if ([other isKindOfClass:[self class]]) {
        if ([self isEqualCurrencyPair:other]) {
            return YES;
        }
    }
                
    return NO;
}

- (BOOL)isQuoteCurrencyEqualJPY
{
    if (JPY == _quoteCurrency.type) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isEqualCurrencyPair:(CurrencyPair *)currencyPair
{
    if (self.baseCurrency.type == currencyPair.baseCurrency.type && self.quoteCurrency.type == currencyPair.quoteCurrency.type) {
        return YES;
    } else {
        return NO;
    }
}

- (NSString *)toCodeString
{
    return [NSString stringWithFormat:@"%@%@", _baseCurrency.toCodeString, _quoteCurrency.toCodeString];
}

- (NSString *)toDisplayString
{
    return [NSString stringWithFormat:@"%@/%@", _baseCurrency.toCodeString, _quoteCurrency.toCodeString];
}

- (NSString *)toCodeReverseString
{
    return [NSString stringWithFormat:@"%@%@", _quoteCurrency.toCodeString, _baseCurrency.toCodeString];
}

- (NSArray *)toArray
{
    return @[_baseCurrency.toCodeString, _quoteCurrency.toCodeString];
}

@end
