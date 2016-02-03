//
//  Currency.m
//  FX Simulator
//
//  Created  on 2014/11/28.
//  
//

#import "Currency.h"

static NSString* const FXSCurrencyKey = @"currency";

@implementation Currency {
    CurrencyType _currencyType;
}

+ (instancetype)allCurrency
{
    return [[Currency alloc] initWithCurrencyType:ALL];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    return [self initWithString:[aDecoder decodeObjectForKey:FXSCurrencyKey]];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:[self toCodeString] forKey:FXSCurrencyKey];
}

- (instancetype)initWithCurrencyType:(CurrencyType)currencyType
{
    if (self = [super init]) {
        _currencyType = currencyType;
        
        if (_currencyType == 0) {
            return nil;
        }
    }
    
    return self;
}

- (instancetype)initWithString:(NSString *)currencyString
{
    _currencyType = [self stringToCurrencyType:currencyString];
    
    return [self initWithCurrencyType:_currencyType];
}

- (BOOL)isEqual:(id)other {
    if (other == self) {
        return YES;
    } else if ([other isKindOfClass:[self class]]) {
        if ([self isEqualCurrency:other]) {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)isAllCurrency
{
    if (self.type == ALL) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isEqualCurrency:(Currency *)currency
{
    if (self.type == ALL || currency.type == ALL) {
        return YES;
    }
    
    if (self.type == currency.type) {
        return YES;
    } else {
        return NO;
    }
}

- (NSString *)toCodeString
{
    return [self currencyTypeToString:_currencyType];
}

- (NSString *)toDisplayString
{
    return [self currencyTypeToString:_currencyType];
}

- (NSString *)toString
{
    return [self currencyTypeToString:_currencyType];
}

- (CurrencyType)type
{
    return _currencyType;
}

- (NSString *)currencyTypeToString:(CurrencyType)currencyType
{
    NSString *result;
    
    switch (currencyType) {
        case USD:
            result = @"USD";
            break;
            
        case JPY:
            result = @"JPY";
            break;
            
        case EUR:
            result = @"EUR";
            break;
            
        case CHF:
            result = @"CHF";
            break;
            
        case GBP:
            result = @"GBP";
            break;
            
        case AUD:
            result = @"AUD";
            break;
            
        case ALL:
            break;
    }
    
    return result;
}

- (CurrencyType)stringToCurrencyType:(NSString *)currencyString
{
    CurrencyType result;
    
    if ([@"USD" isEqualToString:currencyString]) {
        result = USD;
    } else if ([@"JPY" isEqualToString:currencyString]) {
        result = JPY;
    } else if ([@"EUR" isEqualToString:currencyString]) {
        result = EUR;
    } else if ([@"CHF" isEqualToString:currencyString]) {
        result = CHF;
    } else if ([@"GBP" isEqualToString:currencyString]) {
        result = GBP;
    } else if ([@"AUD" isEqualToString:currencyString]) {
        result = AUD;
    } else {
        return 0;
    }
    
    return result;
}

@end
