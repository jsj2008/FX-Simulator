//
//  ForexHistoryFactory.h
//  FX Simulator
//
//  Created  on 2014/11/13.
//  
//

#import <Foundation/Foundation.h>

@class CurrencyPair;
@class ForexHistory;
@class TimeFrame;

@interface ForexHistoryFactory : NSObject
+ (ForexHistory *)createForexHistoryFromCurrencyPair:(CurrencyPair *)currencyPair timeScale:(TimeFrame *)timeScale;
@end
