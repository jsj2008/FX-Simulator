//
//  ForexTimeScaleDataArrayFactory.h
//  FX Simulator
//
//  Created  on 2014/11/14.
//  
//

#import <Foundation/Foundation.h>

@class CurrencyPair;
@class MarketTimeScale;

@interface ForexTimeScaleDataArrayFactory : NSObject
+(NSArray*)createArrayFromMaxCloseTimestamp:(int)closeTimestamp limit:(int)num currencyPair:(CurrencyPair*)currencyPair timeScale:(MarketTimeScale*)timeScale;
@end
