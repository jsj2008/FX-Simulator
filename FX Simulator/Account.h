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
@class OrderType;
@class Rate;

/**
 口座情報を管理するクラス。
 総資産の金額、保有しているポジション、損益など。
*/

@interface Account : NSObject

-(instancetype)initWithAccountCurrency:(Currency *)currency currencyPair:(CurrencyPair *)currencyPair balance:(Balance *)balance openPosition:(OpenPosition *)openPosition;

/**
 マーケットが更新されたときに使う。
 マーケットの状態に応じて、アカウント情報を更新する。
*/
//-(void)updatedMarket;

-(void)updatedSaveData;
-(void)didOrder;

/**
 総資産が０以下かどうか。
*/
-(BOOL)isShortage;

@property (nonatomic, readonly) Rate *averageRate;

/**
 総資産
*/
@property (nonatomic, readonly) Money *equity;

@property (nonatomic, readonly) OrderType *orderType;

/**
 損益
*/
@property (nonatomic, readonly) Money *profitAndLoss;

@property (nonatomic, readonly) Lot *totalLot;

@end
