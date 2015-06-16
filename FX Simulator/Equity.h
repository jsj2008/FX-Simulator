//
//  Equity.h
//  FX Simulator
//
//  Created  on 2014/12/17.
//  
//

#import <Foundation/Foundation.h>

@class Money;
@class Balance;

/**
 口座残高に、そのときの損益(未決済のポジションの損益)を足した、総資産。
*/

@interface Equity : NSObject
-(id)initWithBalance:(Balance*)balance;
-(void)update;
-(void)setCurrentProfitAndLoss:(Money*)profitAndLoss;
/**
 資産が不足しているかどうか。(0以下かどうか)
 */
-(BOOL)isShortage;
@property (nonatomic, readonly) Money *equity;
@end
