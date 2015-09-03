//
//  ForexHistoryFactory.m
//  FX Simulator
//
//  Created  on 2014/11/13.
//  
//

#import "ForexHistoryFactory.h"

#import "ForexHistory.h"

@implementation ForexHistoryFactory

+ (ForexHistory *)createForexHistoryFromCurrencyPair:(CurrencyPair *)currencyPair timeScale:(TimeFrame *)timeScale
{
    return [[ForexHistory alloc] initWithCurrencyPair:currencyPair timeScale:timeScale];
}

@end
