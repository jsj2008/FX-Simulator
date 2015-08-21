//
//  SaveData.h
//  FX Simulator
//
//  Created  on 2014/10/08.
//  
//

#import <Foundation/Foundation.h>

@class CoreDataManager;
@class SaveDataSource;
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
@class OrderHistory;
@class OpenPosition;
@class ExecutionHistory;

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
@property (nonatomic) float autoUpdateIntervalSeconds;
@property (nonatomic, readonly) Chart *mainChart;
@property (nonatomic, readonly) ChartChunk *subChartChunk;
@property (nonatomic, readonly) OrderHistory *orderHistory;
@property (nonatomic, readonly) OpenPosition *openPosition;
@property (nonatomic, readonly) ExecutionHistory *executionHistory;

/**
 テスト時などに、CoreDataManagerをセットする。
 テストが終わったら、nilを入れる。
*/
+ (void)setCoreDataManager:(CoreDataManager *)coreDataManager;

/**
 CoreDataに新しいデフォルトのセーブデータを登録。
 重複するslotNumberのセーブデータは削除される。
*/
+ (instancetype)createDefaultNewSaveDataFromSlotNumber:(NSUInteger)slotNumber;

/**
 CoreDataに新しいセーブデータを登録。
 重複するslotNumberのセーブデータは削除される。
*/
+ (instancetype)createNewSaveDataFromSlotNumber:(NSUInteger)slotNumber currencyPair:(CurrencyPair *)currencyPair timeFrame:(TimeFrame *)timeFrame;

+ (instancetype)loadFromSlotNumber:(NSUInteger)slotNumber;
- (instancetype)initWithSaveDataSource:(SaveDataSource *)source;
@end
