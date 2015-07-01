//
//  Account.h
//  FX Simulator
//
//  Created by yuu on 2015/06/15.
//
//

#import <Foundation/Foundation.h>

@class Market;
@class Money;
@class OpenPosition;

/**
 口座情報を管理するクラス。
 総資産の金額、保有しているポジション、損益など。
*/

@interface Account : NSObject
-(instancetype)initWithMarket:(Market*)market;
/**
 マーケットが更新されたときに使う。
 マーケットの状態に応じて、アカウント情報を更新する。
*/
-(void)updatedMarket;
-(void)didOrder;
/**
 総資産が０以下かどうか。
*/
-(BOOL)isShortage;
/**
 総資産
*/
@property (nonatomic, readonly) Money *equity;
@property (nonatomic, readonly) OpenPosition *openPosition;
/**
 損益
*/
@property (nonatomic, readonly) Money *profitAndLoss;
@end
