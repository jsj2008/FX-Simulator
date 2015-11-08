//
//  OpenPositionRelationChunk.h
//  FXSimulator
//
//  Created by yuu on 2015/09/20.
//
//

#import <Foundation/Foundation.h>

@class Currency;
@class CurrencyPair;
@class Market;
@class Money;
@class PositionSize;
@class PositionType;
@class Rate;

@interface OpenPositionRelationChunk : NSObject

- (instancetype)initWithSaveSlot:(NSUInteger)slot;

/**
 新しいレコードからselectする
 */
- (NSArray *)selectNewestFirstLimit:(NSUInteger)limit currencyPair:(CurrencyPair *)currencyPair;

/**
 古いポジションからselectする
 */
- (NSArray *)selectCloseTargetOpenPositionsLimitClosePositionSize:(PositionSize *)limitPositionSize closeTargetPositionType:(PositionType *)positionType currencyPair:(CurrencyPair *)currencyPair;

- (PositionType *)positionTypeOfCurrencyPair:(CurrencyPair *)currencyPAir;

- (Money *)profitAndLossOfCurrencyPair:(CurrencyPair *)currencyPair ForMarket:(Market *)market InCurrency:(Currency *)currency;

- (PositionSize *)totalPositionSizeOfCurrencyPair:(CurrencyPair *)currencyPair;

- (Rate *)averageRateOfCurrencyPair:(CurrencyPair *)currencyPair;

/**
 新規のポジションを追加できるかどうか
 */
- (BOOL)isExecutableNewPosition;

- (void)delete;

@end
