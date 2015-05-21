//
//  ProfitAndLoss.m
//  FX Simulator
//
//  Created  on 2014/12/04.
//  
//

#import "ProfitAndLossCalculator.h"

#import "Money.h"
#import "CurrencyPair.h"
#import "OrderType.h"
#import "Rate.h"
#import "PositionSize.h"

@implementation ProfitAndLossCalculator

+(Money*)calculateByTargetRate:(Rate*)targetRate valuationRate:(Rate *)valuationRate positionSize:(PositionSize *)positionSize orderType:(OrderType *)orderType
{
    if (![targetRate isEqualCurrencyPair:valuationRate]) {
        return nil;
    }
    
    long long profitAndLoss = 0;
    
    if ([orderType isShort]) {
        profitAndLoss = ([targetRate rateValue] - [valuationRate rateValue]) * positionSize.sizeValue;
    } else if ([orderType isLong]) {
        profitAndLoss = ([valuationRate rateValue] - [targetRate rateValue]) * positionSize.sizeValue;
    } else {
        return nil;
    }
    
    return [[Money alloc] initWithAmount:profitAndLoss currency:targetRate.currencyPair.quoteCurrency];
}

@end
