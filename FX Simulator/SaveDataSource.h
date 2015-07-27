//
//  SaveDataSource.h
//  FXSimulator
//
//  Created by yuu on 2015/07/27.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ChartSource;

@interface SaveDataSource : NSManagedObject

@property (nonatomic, retain) id accountCurrency;
@property (nonatomic) float autoUpdateIntervalSeconds;
@property (nonatomic, retain) id currencyPair;
@property (nonatomic) BOOL isAutoUpdate;
@property (nonatomic, retain) id lastLoadedTime;
@property (nonatomic, retain) id positionSizeOfLot;
@property (nonatomic) int32_t slotNumber;
@property (nonatomic, retain) id spread;
@property (nonatomic, retain) id startBalance;
@property (nonatomic, retain) id startTime;
@property (nonatomic, retain) id timeFrame;
@property (nonatomic, retain) id tradePositionSize;
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
