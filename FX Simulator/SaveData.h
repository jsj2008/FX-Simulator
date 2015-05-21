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
@class MarketTimeScale;
@class MarketTime;

@interface SaveData : NSObject
@property (nonatomic, readonly) int slotNumber;
@property (nonatomic, readonly) CurrencyPair* currencyPair;
@property (nonatomic, readonly) MarketTimeScale *timeScale;
@property (nonatomic, readonly) MarketTime *startTime;
@property (nonatomic, readonly) Spread *spread;
@property (nonatomic, readwrite) MarketTime *lastLoadedCloseTimestamp;
@property (nonatomic, readwrite) Currency* accountCurrency;
@property (nonatomic, readonly) PositionSize *positionSizeOfLot;
@property (nonatomic, readwrite) PositionSize *tradePositionSize;
@property (nonatomic, readonly) Money *startBalance;
@property (nonatomic, readwrite) BOOL isAutoUpdate;
// SaveDataかUserDataか
@property (nonatomic, readwrite) NSNumber *autoUpdateInterval;
@property (nonatomic, readwrite) MarketTimeScale *subChartSelectedTimeScale;
/*@property (nonatomic, readonly) NSString *orderHistoryTableName;
@property (nonatomic, readonly) NSString *executionHistoryTableName;
@property (nonatomic, readonly) NSString *openPositionTableName;*/
@property (nonatomic, readonly) TradeDbDataSource *orderHistoryDataSource;
@property (nonatomic, readonly) TradeDbDataSource *executionHistoryDataSource;
@property (nonatomic, readonly) TradeDbDataSource *openPositionDataSource;
@property (nonatomic, readonly) NSDictionary *saveDataDictionary;
-(id)initWithSaveDataDictionary:(NSDictionary*)dic;
-(id)initWithDefaultDataAndSlotNumber:(int)slotNumber;
@end
