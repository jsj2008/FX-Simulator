//
//  Account.h
//  FX Simulator
//
//  Created by yuu on 2015/06/15.
//
//

#import <Foundation/Foundation.h>

@class Balance;
@class Currency;
@class CurrencyPair;
@class Lot;
@class Market;
@class Money;
@class OpenPosition;
@class PositionSize;
@class PositionType;
@class Rate;

/**
 口座情報を管理するクラス。
 総資産の金額、保有しているポジション、損益など。
*/

@interface Account : NSObject

-(instancetype)initWithAccountCurrency:(Currency *)currency currencyPair:(CurrencyPair *)currencyPair startBalance:(Money *)balance;

/**
 総資産が０以下かどうか。
*/
-(BOOL)isShortage;

@property (nonatomic, readonly) Rate *averageRate;

/**
 総資産
*/
@property (nonatomic, readonly) Money *equity;

@property (nonatomic, readonly) PositionType *orderType;

/**
 損益
*/
@property (nonatomic, readonly) Money *profitAndLoss;

@property (nonatomic, readonly) PositionSize *totalPositionSize;

@end
