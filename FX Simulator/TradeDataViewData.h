//
//  TradeDataViewData.h
//  FX Simulator
//
//  Created  on 2014/12/02.
//  
//

#import <Foundation/Foundation.h>
@import UIKit;

@class ForexHistoryData;
@class Lot;

@interface TradeDataViewData : NSObject
-(void)updateForexHistoryData:(ForexHistoryData*)forexHistoryData;
-(void)didOrder;
//@property (nonatomic, readwrite) ForexHistoryData *currentForexHistoryData;
@property (nonatomic, readonly) NSString *displayOrderType;
@property (nonatomic, readonly) UIColor *displayOrderTypeColor;
@property (nonatomic, readonly) NSString *displayTotalLot;
@property (nonatomic, readonly) NSString *displayAverageRate;
@property (nonatomic, readonly) NSString *displayProfitAndLoss;
@property (nonatomic, readonly) UIColor *displayProfitAndLossColor;
@property (nonatomic, readonly) NSString *displayEquity;
@property (nonatomic, readonly) UIColor *displayEquityColor;
@property (nonatomic, readonly) NSString *displayOpenPositionMarketValue;
//@property (nonatomic, readonly) NSString *defaultTradeLotInputFieldValue;
@property (nonatomic, readwrite) Lot *tradeLot;
@property (nonatomic, readwrite) BOOL isAutoUpdate;
@end
