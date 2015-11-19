//
//  SaveDataSource.h
//  FXSimulator
//
//  Created by yuu on 2015/11/19.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ChartSource;

@interface SaveDataSource : NSManagedObject

@property (nonatomic, retain) id accountCurrency;
@property (nonatomic) float autoUpdateIntervalSeconds;
@property (nonatomic) NSTimeInterval createdAt;
@property (nonatomic, retain) id currencyPairs;
@property (nonatomic) BOOL isAutoUpdate;
@property (nonatomic) NSTimeInterval lastLoadedTime;
@property (nonatomic) int32_t maxLeverage;
@property (nonatomic) int32_t positionSizeOfLot;
@property (nonatomic) int32_t slotNumber;
@property (nonatomic, retain) id spreads;
@property (nonatomic, retain) id startBalance;
@property (nonatomic) NSTimeInterval startTime;
@property (nonatomic) float stopOutLevel;
@property (nonatomic) int32_t timeFrame;
@property (nonatomic) int64_t tradePositionSize;
@property (nonatomic, retain) NSSet *chartSources;
@end

@interface SaveDataSource (CoreDataGeneratedAccessors)

- (void)addChartSourcesObject:(ChartSource *)value;
- (void)removeChartSourcesObject:(ChartSource *)value;
- (void)addChartSources:(NSSet *)values;
- (void)removeChartSources:(NSSet *)values;

@end
