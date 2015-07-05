//
//  Rate.h
//  FX Simulator
//
//  Created  on 2014/12/03.
//  
//

#import "Common.h"

@class MarketTime;
@class CurrencyPair;
@class PositionSize;
@class Spread;
@class Money;

@interface Rate : NSObject
-(id)initWithRateValue:(rate_t)rate currencyPair:(CurrencyPair*)currencyPair timestamp:(MarketTime*)timestamp;
/**
 このRateと対象のRateのCurrencyPairが同じかどうか。
*/
-(BOOL)isEqualCurrencyPair:(Rate*)rate;
/**
 このRateにスプレッドを追加したRateを返す。
*/
-(Rate*)addSpread:(Spread*)spread;
-(Rate*)subRate:(Rate*)rate;
-(NSComparisonResult)compare:(Rate*)rate;
-(Money*)multiplyPositionSize:(PositionSize*)positionSize;
-(NSString*)toDisplayString;
@property (nonatomic, readonly) MarketTime *timestamp;
@property (nonatomic, readonly) CurrencyPair *currencyPair;
@property (nonatomic, readonly) rate_t rateValue;
@property (nonatomic, readonly) NSNumber *rateValueObj;
@end
