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
+ (NSArray *)selectNewestFirstLimit:(NSUInteger)limit currencyPair:(CurrencyPair *)currencyPair saveSlot:(NSUInteger)slot;

/**
 古いポジションからselectする
*/
+ (NSArray *)selectCloseTargetOpenPositionsLimitClosePositionSize:(PositionSize *)limitPositionSize currencyPair:(CurrencyPair *)currencyPair saveSlot:(NSUInteger)slot;

+ (PositionType *)positionTypeOfCurrencyPair:(CurrencyPair *)currencyPAir saveSlot:(NSUInteger)slot;

+ (Money *)profitAndLossOfCurrencyPair:(CurrencyPair *)currencyPair ForMarket:(Market *)market InCurrency:(Currency *)currency saveSlot:(NSUInteger)slot;

+ (PositionSize *)totalPositionSizeOfCurrencyPair:(CurrencyPair *)currencyPair saveSlot:(NSUInteger)slot;

+ (Rate *)averageRateOfCurrencyPair:(CurrencyPair *)currencyPair saveSlot:(NSUInteger)slot;

+ (void)deleteSaveSlot:(NSUInteger)slot;

/**
 新規のポジションを追加できるかどうか
*/
+ (BOOL)isExecutableNewPositionOfSaveSlot:(NSUInteger)slot;

- (ExecutionOrder *)createCloseExecutionOrderFromOrderId:(NSUInteger)orderId rate:(Rate *)rate;

- (BOOL)isNewPosition;

- (void)new;

- (void)close;

- (Money *)profitAndLossFromMarket:(Market *)market;

- (void)displayDataUsingBlock:(void (^)(NSString *currencyPair, NSString *positionType, NSString *rate, NSString *lot, NSString *orderId, NSString *profitAndLoss, NSString *ymdTime, NSString *hmsTime, UIColor *profitAndLossColor))block market:(Market *)market sizeOfLot:(PositionSize *)size displayCurrency:(Currency *)displayCurrency;

@end
