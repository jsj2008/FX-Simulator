//
//  Balance.h
//  FX Simulator
//
//  Created  on 2014/12/17.
//  
//

#import <Foundation/Foundation.h>

@class Currency;
@class Money;
@class ExecutionHistory;

/**
 口座残高。決済されていないポジションの損益に影響を受けない。
 単純に、開始資産に、決済された全てのポジションの損益を足したもの。
*/

@interface Balance : NSObject
-(id)initWithStartBalance:(Money*)balance ExecutionHistory:(ExecutionHistory*)executionHistory;
-(void)updateBalance;
@property (nonatomic, readonly) Currency *currency;
@property (nonatomic, readonly) Money *balance;
@end
