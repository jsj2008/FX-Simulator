//
//  RatePanelViewData.h
//  FX Simulator
//
//  Created  on 2014/11/20.
//  
//

#import <Foundation/Foundation.h>

@class CurrencyPair;
@class ForexHistoryData;
@class Market;
@class OrderType;
@class Rate;
@class PositionSize;
@class Spread;

/**
 UpdateされたMarketをもとに,Controllerに様々なデータを提供する。
*/

@interface RatePanelViewData : NSObject
-(NSString*)getDisplayCurrentBidRate;
-(NSString*)getDisplayCurrentAskRate;
/**
 OrderTypeに対応する最新のレートを返す。例えば、OrderTypeが買いなら、Askレートを返す。売りなら、Bidレートを返す。
*/
-(Rate*)getCurrentRateForOrderType:(OrderType*)orderType;
/**
 現在、何Lot取引するのかをポジションサイズに変換して返す。
*/
-(PositionSize*)currentPositionSize;
-(void)updateCurrentMarket:(Market*)market;
@property (nonatomic, readonly) CurrencyPair *currencyPair;
@property (nonatomic, readonly) Spread *spread;
@end
