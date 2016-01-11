//
//  SaveDataSource+CoreDataProperties.h
//  FXSimulator
//
//  Created by yuu on 2016/01/08.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "SaveDataSource.h"

NS_ASSUME_NONNULL_BEGIN

@interface SaveDataSource (CoreDataProperties)

@property (nullable, nonatomic, retain) id accountCurrency;
@property (nonatomic) float autoUpdateIntervalSeconds;
@property (nonatomic) NSTimeInterval createdAt;
@property (nullable, nonatomic, retain) id currencyPairs;
@property (nonatomic) BOOL isAutoUpdate;
@property (nonatomic) NSTimeInterval lastLoadedTime;
@property (nonatomic) int32_t leverage;
@property (nonatomic) int32_t positionSizeOfLot;
@property (nonatomic) int32_t slotNumber;
@property (nullable, nonatomic, retain) id spreads;
@property (nullable, nonatomic, retain) id startBalance;
@property (nonatomic) NSTimeInterval startTime;
@property (nonatomic) float stopOutLevel;
@property (nonatomic) int32_t timeFrame;
@property (nonatomic) int64_t tradePositionSize;
@property (nullable, nonatomic, retain) NSSet<ChartSource *> *chartSources;

@end

@interface SaveDataSource (CoreDataGeneratedAccessors)

- (void)addChartSourcesObject:(ChartSource *)value;
- (void)removeChartSourcesObject:(ChartSource *)value;
- (void)addChartSources:(NSSet<ChartSource *> *)values;
- (void)removeChartSources:(NSSet<ChartSource *> *)values;

@end

NS_ASSUME_NONNULL_END
