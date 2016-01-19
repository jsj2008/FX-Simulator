//
//  ExecutionOrderRelationChunk.h
//  FXSimulator
//
//  Created by yuu on 2015/09/20.
//
//

#import <Foundation/Foundation.h>

@class CurrencyPair;
@class ExecutionOrder;
@class Money;
@class PositionType;
@class Rate;

@interface ExecutionOrderRelationChunk : NSObject

- (instancetype)initWithSaveSlot:(NSUInteger)slot;

- (void)executionOrderDetail:(void (^)(CurrencyPair *currencyPair, PositionType *positionType, Rate *rate, NSUInteger orderId))block fromExecutionOrderId:(NSUInteger)executionOrderId;

- (ExecutionOrder *)newestCloseOrderOfCurrencyPair:(CurrencyPair *)currencyPair;

- (Money *)profitAndLossOfCurrencyPair:(CurrencyPair *)currencyPair;

- (Money *)profitAndLossOfCurrencyPair:(CurrencyPair *)currencyPair newerThan:(ExecutionOrder *)oldOrder;

- (NSArray *)selectNewestFirstLimit:(NSUInteger)limit;

- (void)delete;

@end
