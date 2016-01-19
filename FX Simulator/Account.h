//
//  Account.h
//  FX Simulator
//
//  Created by yuu on 2015/06/15.
//
//

#import <Foundation/Foundation.h>
#import "OrderManager.h"

@import UIKit;

@class Balance;
@class Currency;
@class CurrencyPair;
@class ExecutionOrderRelationChunk;
@class Leverage;
@class Lot;
@class Market;
@class Money;
@class OpenPosition;
@class OpenPositionRelationChunk;
@class PositionSize;
@class PositionType;
@class Rate;

/**
 口座情報を管理するクラス。
 総資産の金額、保有しているポジション、損益など。
*/

@interface Account : NSObject <OrderManagerState>

- (instancetype)initWithAccountCurrency:(Currency *)currency currencyPair:(CurrencyPair *)currencyPair startBalance:(Money *)balance leverage:(Leverage *)leverage openPositions:(OpenPositionRelationChunk *)openPositions executionOrders:(ExecutionOrderRelationChunk *)executionOrders market:(Market *)market;

- (void)displayDataUsingBlock:(void (^)(NSString *equityStringValue, NSString *profitAndLossStringValue, NSString *orderTypeStringValue, NSString *averageRateStringValue, NSString *totalLotStringValue, UIColor *equityStringColor, UIColor *profitAndLossStringColor))block positionSizeOfLot:(PositionSize *)positionSize;

- (void)didOrder:(OrderResult *)result;

/**
 総資産が０以下かどうか。
*/
- (BOOL)isShortage;

- (void)update;

//- (Money *)equityForMarket:(Market *)market;

//- (Money *)profitAndLossForMarket:(Market *)market;

//@property (nonatomic, readonly) Rate *averageRate;

/**
 総資産
*/
//@property (nonatomic, readonly) Money *equity;

//@property (nonatomic, readonly) PositionType *orderType;

/**
 損益
*/
//@property (nonatomic, readonly) Money *profitAndLoss;

//@property (nonatomic, readonly) PositionSize *totalPositionSize;

@end
