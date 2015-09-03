//
//  SQLiteOpenPositionModel.h
//  FX Simulator
//
//  Created  on 2014/09/09.
//  
//

#import "PositionBase.h"

@class Currency;
@class CurrencyPair;
@class ExecutionOrder;
@class Lot;
@class Market;
@class Money;
@class PositionType;
@class PositionSize;
@class Rate;

@interface OpenPosition : PositionBase

@property (nonatomic, readonly) NSUInteger executionOrderId;
@property (nonatomic, readonly) NSUInteger orderId;

+ (instancetype)createNewOpenPositionFromExecutionOrder:(ExecutionOrder *)order executionOrderId:(NSUInteger)executionOrderId;

/**
 新しいレコードからselectする
*/
+ (NSArray *)selectNewestFirstLimit:(NSUInteger)limit currencyPair:(CurrencyPair *)currencyPair;

/**
 古いポジションからselectする
*/
+ (NSArray *)selectCloseTargetOpenPositionsLimitClosePositionSize:(PositionSize *)limitPositionSize currencyPair:(CurrencyPair *)currencyPair;

+ (PositionType *)positionTypeOfCurrencyPair:(CurrencyPair *)currencyPAir;

+ (Money *)profitAndLossOfCurrencyPair:(CurrencyPair *)currencyPair ForMarket:(Market *)market InCurrency:(Currency *)currency;

+ (PositionSize *)totalPositionSizeOfCurrencyPair:(CurrencyPair *)currencyPair;

+ (Lot *)totalLotOfCurrencyPair:(CurrencyPair *)currencyPair;

+ (Rate *)averageRateOfCurrencyPair:(CurrencyPair *)currencyPair;

/**
 レコード数が最大かどうか。
 */
+ (BOOL)isExecutableNewPosition;

- (BOOL)isNewPosition;

- (void)new;

- (void)close;

- (Money *)profitAndLossFromMarket:(Market *)market;

@end
