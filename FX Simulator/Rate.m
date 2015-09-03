//
//  Rate.m
//  FX Simulator
//
//  Created  on 2014/12/03.
//  
//

#import "Rate.h"

#import "CurrencyPair.h"
#import "Money.h"
#import "PositionSize.h"
#import "Setting.h"
#import "Spread.h"

@implementation Rate

- (instancetype)initWithRateValue:(rate_t)rate currencyPair:(CurrencyPair *)currencyPair timestamp:(Time *)timestamp
{
    if (self = [super init]) {
        _rateValue = rate;
        _currencyPair = currencyPair;
        _timestamp = timestamp;
    }
    
    return self;
}

- (BOOL)isEqualCurrencyPair:(Rate *)rate
{
    if (rate.currencyPair == nil) {
        return NO;
    }
    
    if ([rate.currencyPair isEqualCurrencyPair:self.currencyPair]) {
        return YES;
    } else {
        return NO;
    }
}

- (Rate *)addRate:(Rate *)rate
{
    if (rate == nil) {
        return nil;
    }
    
    if (![self.currencyPair isEqualCurrencyPair:rate.currencyPair]) {
        return nil;
    }
    
    return [[Rate alloc] initWithRateValue:self.rateValue + rate.rateValue currencyPair:self.currencyPair timestamp:self.timestamp];
}

- (Rate *)addSpread:(Spread *)spread
{
    if (![self.currencyPair isEqualCurrencyPair:spread.currencyPair]) {
        return nil;
    }
    
    return [[Rate alloc] initWithRateValue:(self.rateValue + [spread toRate].rateValue) currencyPair:self.currencyPair timestamp:self.timestamp];
}

- (Rate *)divide:(NSUInteger)num
{
    return [[Rate alloc] initWithRateValue:self.rateValue/num  currencyPair:self.currencyPair timestamp:self.timestamp];
}

- (Rate *)subRate:(Rate *)rate
{
    Rate *addRate = [[Rate alloc] initWithRateValue:-(rate.rateValue) currencyPair:self.currencyPair timestamp:self.timestamp];
    
    return [self addRate:addRate];
}

- (NSComparisonResult)compare:(Rate *)rate
{
    return [self.rateValueObj compare:rate.rateValueObj];
}

- (Money *)multiplyPositionSize:(PositionSize *)positionSize
{
    return [[Money alloc] initWithAmount:(self.rateValue * positionSize.sizeValue) currency:self.currencyPair.quoteCurrency];
}

- (NSNumber *)rateValueObj
{
    return [NSNumber numberWithDouble:self.rateValue];
}

- (NSString *)toDisplayString
{
    return [Setting toStringFromRate:self];
}

@end
