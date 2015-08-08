//
//  SaveDataSource+Additions.h
//  FXSimulator
//
//  Created by yuu on 2015/08/08.
//
//

#import "SaveDataSource.h"

@class Currency;
@class CurrencyPair;
@class Spread;
@class PositionSize;
@class Lot;
@class Money;
@class TimeFrame;
@class MarketTime;

@interface SaveDataSource (Additions)
@property (nonatomic) NSUInteger fxsSlotNumber;
@property (nonatomic) CurrencyPair* fxsCurrencyPair;
@property (nonatomic) TimeFrame *fxsTimeFrame;
@property (nonatomic) MarketTime *fxsStartTime;
@property (nonatomic) Spread *fxsSpread;
@property (nonatomic) MarketTime *fxsLastLoadedTime;
@property (nonatomic) Currency *fxsAccountCurrency;
@property (nonatomic) PositionSize *fxsPositionSizeOfLot;
@property (nonatomic) PositionSize *fxsTradePositionSize;
@property (nonatomic) Money *fxsStartBalance;
@property (nonatomic) BOOL fxsIsAutoUpdate;
@property (nonatomic) float fxsAutoUpdateIntervalSeconds;
- (void)setDefaultDataAndSlotNumber:(NSUInteger)slotNumber;
@end
