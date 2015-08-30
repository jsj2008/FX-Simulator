//
//  Order.h
//  FX Simulator
//
//  Created  on 2014/11/23.
//  
//

#import <Foundation/Foundation.h>

@class FMResultSet;
@class CurrencyPair;
@class OrderType;
@class Rate;
@class PositionSize;
@class Spread;

@interface Order : NSObject

@property (nonatomic) NSUInteger orderHistoryId;
@property (nonatomic ,readonly) CurrencyPair *currencyPair;
@property (nonatomic, readonly) OrderType *orderType;
@property (nonatomic, readonly) Rate *orderRate;
@property (nonatomic) PositionSize *positionSize;
@property (nonatomic, readonly) Spread *orderSpread;

- (instancetype)initWithFMResultSet:(FMResultSet *)resultSet;
- (instancetype)initWithOrderHistoryId:(NSUInteger)orderHistoryId CurrencyPair:(CurrencyPair *)currencyPair orderType:(OrderType *)orderType orderRate:(Rate *)orderRate positionSize:(PositionSize *)positionSize orderSpread:(Spread *)spread;

/**
 単純なコピー
*/
- (instancetype)copyOrder;

- (BOOL)includeCloseOrder;

@end
