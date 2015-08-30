//
//  UsersOrder.h
//  FX Simulator
//
//  Created  on 2014/09/08.
//  
//

#import "Order.h"

@class CurrencyPair;
@class OrderType;
@class ForexHistoryData;
@class PositionSize;
@class Rate;
@class Spread;

@interface UsersOrder : Order

/**
 決済注文が含まれているかどうか。
*/
-(BOOL)includeCloseOrder;

@end
