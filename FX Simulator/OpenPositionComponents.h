//
//  OpenPositionComponents.h
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

@interface OpenPositionComponents : NSObject
@property (nonatomic) NSUInteger saveSlot;
@property (nonatomic) CurrencyPair *currencyPair;
@property (nonatomic) PositionType *positionType;
@property (nonatomic) Rate *rate;
@property (nonatomic) PositionSize *positionSize;
@property (nonatomic) NSUInteger recordId;
@property (nonatomic) NSUInteger executionOrderId;
@property (nonatomic) NSUInteger orderId;
@property (nonatomic) BOOL isNewPosition;
@end
