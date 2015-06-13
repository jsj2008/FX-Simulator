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
+(UsersOrder*)createFromCurrencyPair:(CurrencyPair*)currencyPair orderType:(OrderType*)orderType positionSize:(PositionSize*)positionSize rate:(Rate*)rate orderSpread:(Spread*)spread;
/**
 決済注文が含まれているかどうか。
*/
-(BOOL)includeCloseOrder;
//+(UsersOrder*)createFromOrderType:(OrderType*)orderType positionSize:(PositionSize*)positionSize rate:(Rate*)rate;
//-(void)setShort;
//-(void)setLong;
@end
