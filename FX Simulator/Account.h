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

@interface Account : NSObject
+(Account*)sharedAccount;
-(void)updatedMarket;
-(void)didOrder;
-(BOOL)isShortage;
@property (nonatomic, readonly) Money *equity;
@property (nonatomic, readonly) OpenPosition *openPosition;
@property (nonatomic, readonly) Money *profitAndLoss;
@end
