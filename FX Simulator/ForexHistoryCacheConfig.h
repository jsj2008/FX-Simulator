//
//  ForexHistoryConfig.h
//  FX Simulator
//
//  Created  on 2014/10/30.
//  
//

#import <Foundation/Foundation.h>

@class CurrencyPair;

@interface ForexHistoryCacheConfig : NSObject
@property (nonatomic) CurrencyPair *currencyPair;
@property (nonatomic) int timeScale;
@end
