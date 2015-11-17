//
//  SaveDataSource.h
//  FXSimulator
//
//  Created by yuu on 2015/11/17.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ChartSource;

@interface SaveDataSource : NSManagedObject

@property (nonatomic, retain) id accountCurrency;
@property (nonatomic) float autoUpdateIntervalSeconds;
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
@property (nonatomic) NSTimeInterval createdAt;
@property (nonatomic, retain) NSSet *mainChartSources;
@property (nonatomic, retain) NSSet *subChartSources;
@end

@interface SaveDataSource (CoreDataGeneratedAccessors)

- (void)addMainChartSourcesObject:(ChartSource *)value;
- (void)removeMainChartSourcesObject:(ChartSource *)value;
- (void)addMainChartSources:(NSSet *)values;
- (void)removeMainChartSources:(NSSet *)values;

- (void)addSubChartSourcesObject:(ChartSource *)value;
- (void)removeSubChartSourcesObject:(ChartSource *)value;
- (void)addSubChartSources:(NSSet *)values;
- (void)removeSubChartSources:(NSSet *)values;

@end
