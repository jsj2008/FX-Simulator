//
//  SaveData.h
//  FX Simulator
//
//  Created  on 2014/10/08.
//  
//

#import <Foundation/Foundation.h>
#import "SaveDataBase.h"

@class Account;
@class Chart;
@class ChartChunk;
@class Currency;
@class CurrencyPair;
@class ExecutionOrderRelationChunk;
@class Time;
@class Lot;
@class Money;
@class OpenPositionRelationChunk;
@class PositionSize;
@class Spread;
@class TimeFrame;

@interface SaveData : SaveDataBase

@property (nonatomic, readonly) NSUInteger slotNumber;
@property (nonatomic) BOOL isAutoUpdate;
@property (nonatomic) float autoUpdateIntervalSeconds;
@property (nonatomic, readonly) Chart *mainChart;
@property (nonatomic, readonly) ChartChunk *subChartChunk;
@property (nonatomic, readonly) Account *account;
@property (nonatomic, readonly) OpenPositionRelationChunk *openPositions;
@property (nonatomic, readonly) ExecutionOrderRelationChunk *executionOrders;

+ (instancetype)createNewSaveData;

+ (instancetype)createDefaultNewSaveData;

+ (instancetype)loadFromSlotNumber:(NSUInteger)slotNumber;

- (void)delete;

- (void)saveWithCompletion:(void (^)())completion error:(void (^)())error;

@end
