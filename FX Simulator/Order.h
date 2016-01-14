//
//  Order.h
//  FX Simulator
//
//  Created  on 2014/11/23.
//  
//

#import "PositionBase.h"

@import UIKit;

@class FMResultSet;
@class Money;
@class OpenPosition;

@interface Order : PositionBase

@property (nonatomic, readonly) CurrencyPair *currencyPair;
@property (nonatomic, readonly) PositionType *positionType;
@property (nonatomic, readonly) PositionSize *positionSize;
@property (nonatomic, readonly) BOOL isNew;
@property (nonatomic, readonly) BOOL isClose;

+ (void)deleteSaveSlot:(NSUInteger)slot;

- (instancetype)copyOrderForNewPositionSize:(PositionSize *)positionSize;

- (NSArray *)createExecutionOrders;

- (void)setNewOrder;

- (void)setCloseOrder;

/**
 Orderに含まれている新規ポジション注文のポジション金額
*/
- (Money *)newPositionValue;

@end
