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

+ (instancetype)loadBalance;

- (instancetype)initWithStartBalance:(Money *)balance ExecutionHistory:(ExecutionHistory *)executionHistory;

- (Money *)balanceInCurrency:(Currency *)currency;

@end
