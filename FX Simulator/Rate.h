//
//  Rate.h
//  FX Simulator
//
//  Created  on 2014/12/03.
//  
//

#import "Common.h"

@class CurrencyPair;
@class Money;
@class PositionSize;
@class Spread;
@class Time;

@interface Rate : NSObject

@property (nonatomic, readonly) Time *timestamp;
@property (nonatomic, readonly) CurrencyPair *currencyPair;
@property (nonatomic, readonly) rate_t rateValue;
@property (nonatomic, readonly) NSNumber *rateValueObj;

- (instancetype)initWithRateValue:(rate_t)rate currencyPair:(CurrencyPair *)currencyPair timestamp:(Time *)timestamp;

/**
 このRateと対象のRateのCurrencyPairが同じかどうか。
*/
- (BOOL)isEqualCurrencyPair:(Rate *)rate;
- (Rate *)addRate:(Rate *)rate;

/**
 このRateにスプレッドを追加したRateを返す。
*/
- (Rate *)addSpread:(Spread *)spread;
- (Rate *)divide:(NSUInteger)num;
- (Rate *)subRate:(Rate *)rate;
- (NSComparisonResult)compare:(Rate *)rate;
- (Money *)multiplyPositionSize:(PositionSize *)positionSize;
- (NSString *)toDisplayString;
@end
