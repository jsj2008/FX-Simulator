//
//  ForexHistoryFactory.h
//  FX Simulator
//
//  Created  on 2014/11/13.
//  
//

#import <Foundation/Foundation.h>

@class ForexHistory;
@class CurrencyPair;
@class MarketTimeScale;

@interface ForexHistoryFactory : NSObject
+(ForexHistory*)createForexHistoryFromCurrencyPair:(CurrencyPair*)currencyPair timeScale:(MarketTimeScale*)timeScale;
@end
