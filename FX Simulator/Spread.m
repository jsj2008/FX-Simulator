//
//  Spread.m
//  FX Simulator
//
//  Created  on 2014/12/03.
//  
//

#import "Spread.h"

#import "CurrencyPair.h"
#import "Rate.h"
#import "Setting.h"


@implementation Spread

// NewStartの新しいSaveData作成のところでは、currencyPairにnil入れている。
-(id)initWithPips:(spread_t)pips currencyPair:(CurrencyPair *)currencyPair
{
    if (self = [super init]) {
        _spreadValue = pips;
        _currencyPair = currencyPair;
    }
    
    return self;
}

-(NSNumber*)spreadValueObj
{
    return [NSNumber numberWithDouble:self.spreadValue];
}

-(Rate*)toRate
{
    if (self.currencyPair == nil) {
        return nil;
    }
    
    Rate *spreadRate = [Setting onePipValueOfCurrencyPair:self.currencyPair];
    
    return [[Rate alloc] initWithRateValue:spreadRate.rateValue*self.spreadValue currencyPair:self.currencyPair timestamp:nil];
}

-(NSString*)toDisplayString
{
    return [self.spreadValueObj stringValue];
}

@end
