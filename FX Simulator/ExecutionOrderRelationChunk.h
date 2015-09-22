//
//  ExecutionOrderRelationChunk.h
//  FXSimulator
//
//  Created by yuu on 2015/09/20.
//
//

#import <Foundation/Foundation.h>

@class CurrencyPair;
@class Money;
@class PositionType;
@class Rate;

@interface ExecutionOrderRelationChunk : NSObject

- (instancetype)initWithSaveSlot:(NSUInteger)slot;

- (void)executionOrderDetail:(void (^)(CurrencyPair *currencyPair, PositionType *positionType, Rate *rate, NSUInteger orderId))block fromExecutionOrderId:(NSUInteger)executionOrderId;

- (Money *)profitAndLossOfCurrencyPair:(CurrencyPair *)currencyPair;

- (NSArray *)selectNewestFirstLimit:(NSUInteger)limit;

@end
