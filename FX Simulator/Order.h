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
@class ExecutionOrder;
@class Money;
@class NormalizedOrdersFactory;
@class OpenPosition;

@interface Order : PositionBase

@property (nonatomic, readonly) CurrencyPair *currencyPair;
@property (nonatomic, readonly) PositionType *positionType;
@property (nonatomic, readonly) PositionSize *positionSize;
@property (nonatomic, readonly) BOOL isNew;
@property (nonatomic, readonly) BOOL isClose;

+ (void)deleteSaveSlot:(NSUInteger)slot;

- (instancetype)initWithSaveSlot:(NSUInteger)slot CurrencyPair:(CurrencyPair *)currencyPair positionType:(PositionType *)positionType rate:(Rate *)rate positionSize:(PositionSize *)positionSize normalizedOrdersFactory:(NormalizedOrdersFactory *)normalizedOrdersFactory;

- (instancetype)copyOrderForNewOrder;

- (instancetype)copyOrderForCloseOrder;

- (instancetype)copyOrderForNewPositionSize:(PositionSize *)positionSize;

- (NSArray<ExecutionOrder *> *)createExecutionOrders;

/**
 Orderに含まれている新規ポジション注文のポジション金額
*/
- (Money *)newPositionValue;

@end
