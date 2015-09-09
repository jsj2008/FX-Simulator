//
//  SQLiteOpenPositionModel.h
//  FX Simulator
//
//  Created  on 2014/09/09.
//  
//

#import "PositionBase.h"

@import UIKit;

@class Currency;
@class CurrencyPair;
@class ExecutionOrder;
@class Lot;
@class Market;
@class Money;
@class OpenPositionComponents;
@class PositionType;
@class PositionSize;
@class Rate;

@interface OpenPosition : PositionBase

+ (instancetype)openPositionWithBlock:(void (^)(OpenPositionComponents *components))block;

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

+ (Rate *)averageRateOfCurrencyPair:(CurrencyPair *)currencyPair;

/**
 新規のポジションを追加できるかどうか
*/
+ (BOOL)isExecutableNewPosition;

- (ExecutionOrder *)createCloseExecutionOrderFromOrderId:(NSUInteger)orderId;

- (BOOL)isNewPosition;

- (void)new;

- (void)close;

- (Money *)profitAndLossFromMarket:(Market *)market;

- (void)displayDataUsingBlock:(void (^)(NSString *currencyPair, NSString *positionType, NSString *rate, NSString *lot, NSString *orderId, NSString *profitAndLoss, NSString *ymdTime, NSString *hmsTime, UIColor *profitAndLossColor))block market:(Market *)market sizeOfLot:(PositionSize *)size displayCurrency:(Currency *)displayCurrency;

@end