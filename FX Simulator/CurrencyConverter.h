//
//  CurrencyConverter.h
//  FX Simulator
//
//  Created  on 2014/12/04.
//  
//

#import <Foundation/Foundation.h>

@class Money;
@class Currency;

@interface CurrencyConverter : NSObject
+ (Money *)convert:(Money *)money to:(Currency *)currency;
@end
