//
//  Spread.h
//  FX Simulator
//
//  Created  on 2014/12/03.
//  
//

#import <Foundation/Foundation.h>
#import "Common.h"

@class CurrencyPair;
@class Rate;

@interface Spread : NSObject <NSCoding>
-(id)initWithPips:(spread_t)pips currencyPair:(CurrencyPair*)currencyPair;
/**
 スプレッド(Pips)をレートに変換する。例 ドル円 1pip => 0.01円
*/
-(Rate*)toRate;
-(NSString*)toDisplayString;
@property (nonatomic, readonly) CurrencyPair *currencyPair;
@property (nonatomic, readonly) spread_t spreadValue;
@property (nonatomic, readonly) NSNumber *spreadValueObj;
//-(double)doubleValueWithCurrencyPair:(CurrencyPair*)currencyPair;
//@property (nonatomic, readonly) float pips;
@end
