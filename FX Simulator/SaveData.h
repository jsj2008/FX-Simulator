//
//  SaveData.h
//  FX Simulator
//
//  Created  on 2014/10/08.
//  
//

#import <Foundation/Foundation.h>

@class SaveDataSource;
@class TradeDbDataSource;
@class Chart;
@class ChartChunk;
@class Currency;
@class CurrencyPair;
@class Spread;
@class PositionSize;
@class Lot;
@class Money;
@class TimeFrame;
@class MarketTime;

@interface SaveData : NSObject
@property (nonatomic, readonly) NSUInteger slotNumber;
@property (nonatomic) CurrencyPair* currencyPair;
@property (nonatomic) TimeFrame *timeFrame;
@property (nonatomic) MarketTime *startTime;
@property (nonatomic) Spread *spread;
@property (nonatomic) MarketTime *lastLoadedTime;
@property (nonatomic) Currency* accountCurrency;
@property (nonatomic) PositionSize *positionSizeOfLot;
@property (nonatomic) PositionSize *tradePositionSize;
@property (nonatomic) Money *startBalance;
@property (nonatomic) BOOL isAutoUpdate;
// SaveDataかUserDataか
@property (nonatomic) float autoUpdateIntervalSeconds;
@property (nonatomic, readonly) Chart *mainChart;
@property (nonatomic, readonly) ChartChunk *subChartChunk;
#warning OpenPositionなどをそのまま返すようにする。
@property (nonatomic, readonly) TradeDbDataSource *orderHistoryDataSource;
@property (nonatomic, readonly) TradeDbDataSource *executionHistoryDataSource;
@property (nonatomic, readonly) TradeDbDataSource *openPositionDataSource;
@property (nonatomic, readonly) NSDictionary *saveDataDictionary;
+ (instancetype)createDefaultSaveDataFromSlotNumber:(NSUInteger)slotNumber;
- (instancetype)initWithSaveDataSource:(SaveDataSource *)source;
- (void)newSave;
- (void)updateSave;
@end
