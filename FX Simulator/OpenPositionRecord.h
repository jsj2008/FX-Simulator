//
//  OpenPositionRecord.h
//  FX Simulator
//
//  Created  on 2014/07/15.
//  
//

#import <Foundation/Foundation.h>

@class NewExecutionOrder;
@class FMResultSet;
@class OpenPositionRawRecord;
@class ExecutionHistoryRecord;
@class CurrencyPair;
@class OrderType;
@class Rate;
@class PositionSize;
@class Spread;
@class Money;

/*@protocol OpenPositionRecord
@property int openPositionNumber;
@property int orderNumber;
@property int ratesId;
@property double orderRate;
@property OrderType *orderType;
@property unsigned long long positionSize;
@end*/

@interface OpenPositionRecord : NSObject
-(id)initWithNewExecutionOrder:(NewExecutionOrder*)order;
-(id)initWithOpenPositionRawRecord:(OpenPositionRawRecord*)rawRecord executionHistoryRecord:(ExecutionHistoryRecord*)record;
-(Money*)profitAndLossForRate:(Rate*)rate;
@property (nonatomic, readonly) int executionOrderID;
@property (nonatomic, readonly) int openPositionNumber;
@property (nonatomic, readonly) NSNumber *usersOrderNumber;
@property (nonatomic, readonly) CurrencyPair *currencyPair;
//@property (nonatomic, readonly) int ratesId;
@property (nonatomic, readonly) Rate *orderRate;
@property (nonatomic, readonly) Spread *orderSpread;
@property (nonatomic, readonly) OrderType *orderType;
@property (nonatomic) PositionSize *positionSize;
@property (nonatomic) BOOL isAllPositionSize;
@end
