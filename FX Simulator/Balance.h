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

@interface Balance : NSObject
-(id)initWithStartBalance:(Money*)balance ExecutionHistory:(ExecutionHistory*)executionHistory;
-(void)updateBalance;
@property (nonatomic, readonly) Currency *currency;
@property (nonatomic, readonly) Money *balance;
@end
