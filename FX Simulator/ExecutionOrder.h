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
@class Money;
@class OpenPosition;
@class Order;
@class PositionType;
@class Rate;

@interface ExecutionOrder : PositionBase

@property (nonatomic, readonly) Money *profitAndLoss;

+ (instancetype)orderWithBlock:(void (^)(ExecutionOrderComponents *components))block;

+ (void)executionOrderDetail:(void (^)(CurrencyPair *currencyPair, PositionType *positionType, Rate *rate, NSUInteger orderId))block fromExecutionOrderId:(NSUInteger)executionOrderId;

+ (Money *)profitAndLossOfCurrencyPair:(CurrencyPair *)currencyPair;

+ (NSArray *)selectNewestFirstLimit:(NSUInteger)limit;

- (void)displayDataUsingBlock:(void (^)(NSString *currencyPair, NSString *positionType, NSString *rate, NSString *lot, NSString *orderId, NSString *closeTargetOrderId, NSString *profitAndLoss, NSString *ymdTime, NSString *hmsTime, UIColor *profitAndLossColor))block sizeOfLot:(PositionSize *)size displayCurrency:(Currency *)displayCurrency;

- (void)execute;

@end