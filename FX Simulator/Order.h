//
//  Order.h
//  FX Simulator
//
//  Created  on 2014/11/23.
//  
//

#import "OrderBase.h"

@import UIKit;

@class FMResultSet;
@class OpenPosition;

@interface Order : PositionBase

@property (nonatomic, readonly) CurrencyPair *currencyPair;
@property (nonatomic, readonly) PositionType *positionType;
@property (nonatomic, readonly) PositionSize *positionSize;
@property (nonatomic, readonly) BOOL isNew;
@property (nonatomic, readonly) BOOL isClose;

- (instancetype)copyOrderForNewPositionSize:(PositionSize *)positionSize;

- (NSArray *)createExecutionOrders;

- (void)setNewOrder;

- (void)setCloseOrder;

@end
