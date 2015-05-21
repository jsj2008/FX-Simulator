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

@interface Equity : NSObject
-(id)initWithBalance:(Balance*)balance;
-(void)updateBalance;
-(void)setCurrentProfitAndLoss:(Money*)profitAndLoss;
@property (nonatomic, readonly) Money *equity;
@end
