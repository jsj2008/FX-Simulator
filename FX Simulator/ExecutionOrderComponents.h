//
//  ExecutionOrderComponents.h
//  FXSimulator
//
//  Created by yuu on 2015/09/08.
//
//

#import <Foundation/Foundation.h>

@class CurrencyPair;
@class PositionType;
@class Rate;
@class PositionSize;
@class OpenPosition;

@interface ExecutionOrderComponents : NSObject
@property (nonatomic) CurrencyPair *currencyPair;
@property (nonatomic) PositionType *positionType;
@property (nonatomic) Rate *rate;
@property (nonatomic) PositionSize *positionSize;
@property (nonatomic) NSUInteger recordId;
@property (nonatomic) NSUInteger orderId;
@property (nonatomic) BOOL isNew;
@property (nonatomic) BOOL isClose;
@property (nonatomic) BOOL willExecuteOrder;
@property (nonatomic) NSUInteger closeTargetExecutionOrderId;
@property (nonatomic) NSUInteger closeTargetOrderId;
@property (nonatomic) OpenPosition *willExecuteCloseTargetOpenPosition;
@end
