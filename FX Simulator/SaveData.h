//
//  SaveData.h
//  FX Simulator
//
//  Created  on 2014/10/08.
//  
//

#import <Foundation/Foundation.h>

@class Account;
@class Chart;
@class ChartChunk;
@class Currency;
@class CurrencyPair;
@class Time;
@class Lot;
@class Money;
@class PositionSize;
@class Spread;
@class TimeFrame;

@interface SaveData : NSObject

@property (nonatomic, readonly) NSUInteger slotNumber;
@property (nonatomic) CurrencyPair* currencyPair;
@property (nonatomic) TimeFrame *timeFrame;
@property (nonatomic) Time *startTime;
@property (nonatomic) Spread *spread;
@property (nonatomic) Time *lastLoadedTime;
@property (nonatomic) Currency* accountCurrency;
@property (nonatomic) PositionSize *positionSizeOfLot;
@property (nonatomic) PositionSize *tradePositionSize;
@property (nonatomic) Money *startBalance;
@property (nonatomic) BOOL isAutoUpdate;
@property (nonatomic) float autoUpdateIntervalSeconds;
@property (nonatomic, readonly) Chart *mainChart;
@property (nonatomic, readonly) ChartChunk *subChartChunk;
@property (nonatomic, readonly) Account *account;

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
@end
