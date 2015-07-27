//
//  SaveData.h
//  FX Simulator
//
//  Created  on 2014/10/08.
//  
//

#import <Foundation/Foundation.h>

@class TradeDbDataSource;
@class Currency;
@class CurrencyPair;
@class Spread;
@class PositionSize;
@class Lot;
@class Money;
@class TimeFrame;
@class MarketTime;

@interface SaveData : NSObject
@property (nonatomic, readwrite) int slotNumber;
@property (nonatomic, readwrite) CurrencyPair* currencyPair;
@property (nonatomic, readwrite) TimeFrame *timeScale;
@property (nonatomic, readwrite) MarketTime *startTime;
@property (nonatomic, readwrite) Spread *spread;
@property (nonatomic, readwrite) MarketTime *lastLoadedCloseTimestamp;
@property (nonatomic, readwrite) Currency* accountCurrency;
@property (nonatomic, readwrite) PositionSize *positionSizeOfLot;
@property (nonatomic, readwrite) PositionSize *tradePositionSize;
@property (nonatomic, readwrite) Money *startBalance;
@property (nonatomic, readwrite) BOOL isAutoUpdate;
// SaveDataかUserDataか
@property (nonatomic, readwrite) NSNumber *autoUpdateInterval;
@property (nonatomic, readwrite) TimeFrame *subChartSelectedTimeScale;
/*@property (nonatomic, readonly) NSString *orderHistoryTableName;
@property (nonatomic, readonly) NSString *executionHistoryTableName;
@property (nonatomic, readonly) NSString *openPositionTableName;*/
#warning OpenPositionなどをそのまま返すようにする。
@property (nonatomic, readonly) TradeDbDataSource *orderHistoryDataSource;
@property (nonatomic, readonly) TradeDbDataSource *executionHistoryDataSource;
@property (nonatomic, readonly) TradeDbDataSource *openPositionDataSource;
@property (nonatomic, readonly) NSDictionary *saveDataDictionary;
-(id)initWithSaveDataDictionary:(NSDictionary*)dic;
-(id)initWithDefaultDataAndSlotNumber:(int)slotNumber;
@end
