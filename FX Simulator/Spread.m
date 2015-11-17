//
//  Spread.m
//  FX Simulator
//
//  Created  on 2014/12/03.
//  
//

#import "Spread.h"

#import "CurrencyPair.h"
#import "FXSComparisonResult.h"
#import "Rate.h"
#import "Setting.h"

static NSString* const FXSSpreadValueKey = @"spreadValue";
static NSString* const FXSCurrencyPairKey = @"currencyPair";

@implementation Spread

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    return [self initWithPips:[aDecoder decodeDoubleForKey:FXSSpreadValueKey] currencyPair:[aDecoder decodeObjectForKey:FXSCurrencyPairKey]];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeDouble:self.spreadValue forKey:FXSSpreadValueKey];
    [aCoder encodeObject:self.currencyPair forKey:FXSCurrencyPairKey];
}

// NewStartの新しいSaveData作成のところでは、currencyPairにnil入れている。
- (instancetype)initWithPips:(spread_t)pips currencyPair:(CurrencyPair *)currencyPair
{
    if (self = [super init]) {
        _spreadValue = pips;
        _currencyPair = currencyPair;
    }
    
    return self;
}

- (instancetype)initWithNumber:(NSNumber *)number currencyPair:(CurrencyPair *)currencyPair
{
    return [self initWithPips:number.doubleValue currencyPair:currencyPair];
}

-(instancetype)initWithString:(NSString *)string currencyPair:(CurrencyPair *)currencyPair
{
    return [self initWithPips:string.doubleValue currencyPair:currencyPair];
}

- (FXSComparisonResult *)compareSpread:(Spread *)spread
{
    if (![self.currencyPair isEqualCurrencyPair:spread.currencyPair]) {
        return nil;
    }
    
    return [[FXSComparisonResult alloc] initWithComparisonResult:[self.spreadValueObj compare:spread.spreadValueObj]];
}

- (NSNumber *)spreadValueObj
{
    return [NSNumber numberWithDouble:self.spreadValue];
}

- (Rate *)toRate
{
    if (self.currencyPair == nil) {
        return nil;
    }
    
    Rate *spreadRate = [Setting onePipValueOfCurrencyPair:self.currencyPair];
    
    return [[Rate alloc] initWithRateValue:spreadRate.rateValue*self.spreadValue currencyPair:self.currencyPair timestamp:nil];
}

- (NSString *)toDisplayString
{
    return [self.spreadValueObj stringValue];
}

@end
