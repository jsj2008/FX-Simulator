//
//  Order.h
//  FX Simulator
//
//  Created  on 2014/11/23.
//  
//

#import <Foundation/Foundation.h>

@class CurrencyPair;
//@class ForexHistoryData;
@class OrderType;
@class Rate;
@class PositionSize;
@class Spread;

@interface Order : NSObject
-(id)initWithCurrencyPair:(CurrencyPair*)currencyPair orderType:(OrderType*)orderType orderRate:(Rate*)orderRate positionSize:(PositionSize*)positionSize orderSpread:(Spread *)spread;
@property (nonatomic ,readonly) CurrencyPair *currencyPair;
//@property (nonatomic, readonly) ForexHistoryData *forexHistoryData;
@property (nonatomic, readonly) OrderType *orderType;
@property (nonatomic, readonly) Rate *orderRate;
@property (nonatomic, readonly) PositionSize *positionSize;
@property (nonatomic, readonly) Spread *orderSpread;
@end
