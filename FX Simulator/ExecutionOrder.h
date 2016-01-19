//
//  ExecutionOrder.h
//  FX Simulator
//
//  Created  on 2014/11/23.
//  
//

#import "PositionBase.h"

@import UIKit;

@class FMResultSet;
@class Currency;
@class CurrencyPair;
@class ExecutionOrderComponents;
@class FXSComparisonResult;
@class Money;
@class OpenPosition;
@class Order;
@class PositionType;
@class Rate;

@interface ExecutionOrder : PositionBase

@property (nonatomic, readonly) Money *profitAndLoss;

+ (instancetype)orderWithBlock:(void (^)(ExecutionOrderComponents *components))block;

+ (void)executionOrderDetail:(void (^)(CurrencyPair *currencyPair, PositionType *positionType, Rate *rate, NSUInteger orderId))block fromExecutionOrderId:(NSUInteger)executionOrderId saveSlot:(NSUInteger)slot;

+ (void)enumerateExecutionOrderDetail:(void (^)(CurrencyPair *currencyPair, PositionType *positionType, Rate *rate, NSUInteger executionOrderId, NSUInteger orderId))block fromExecutionOrderIds:(NSArray<NSNumber *> *)executionOrderIds saveSlot:(NSUInteger)slot;

+ (ExecutionOrder *)newestCloseOrderOfSaveSlot:(NSUInteger)slot currencyPair:(CurrencyPair *)currencyPair;

+ (Money *)profitAndLossOfSaveSlot:(NSUInteger)slot currencyPair:(CurrencyPair *)currencyPair;

+ (Money *)profitAndLossOfSaveSlot:(NSUInteger)slot currencyPair:(CurrencyPair *)currencyPair newerThan:(ExecutionOrder *)oldOrder;

+ (NSArray *)selectNewestFirstLimit:(NSUInteger)limit saveSlot:(NSUInteger)slot;

+ (void)deleteSaveSlot:(NSUInteger)slot;

- (FXSComparisonResult *)compareExecutedOrder:(ExecutionOrder *)order;

- (void)displayDataUsingBlock:(void (^)(NSString *currencyPair, NSString *positionType, NSString *rate, NSString *lot, NSString *orderId, NSString *closeTargetOrderId, NSString *profitAndLoss, NSString *ymdTime, NSString *hmsTime, UIColor *profitAndLossColor))block sizeOfLot:(PositionSize *)size displayCurrency:(Currency *)displayCurrency;

- (void)execute;

@end
