//
//  OrderFactory.h
//  FXSimulator
//
//  Created by yuu on 2016/01/14.
//
//

#import <Foundation/Foundation.h>

@class OpenPositionRelationChunk;
@class Order;
@class CurrencyPair;
@class Time;
@class PositionSize;
@class PositionType;
@class Rate;

@interface OrderFactory : NSObject
- (instancetype)initWithSaveSlot:(NSUInteger)slot openPositions:(OpenPositionRelationChunk *)openPositions;
- (Order *)orderWithCurrencyPair:(CurrencyPair *)currencyPair positionType:(PositionType *)positionType rate:(Rate *)rate positionSize:(PositionSize *)positionSize;
@end
