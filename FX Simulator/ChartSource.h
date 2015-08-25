//
//  ChartSource.h
//  
//
//  Created by yuu on 2015/08/25.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CandleSource, SaveDataSource, SimpleMovingAverageSource;

@interface ChartSource : NSManagedObject

@property (nonatomic) int32_t chartIndex;
@property (nonatomic, retain) id currencyPair;
@property (nonatomic) int32_t displayDataCount;
@property (nonatomic) BOOL isDisplay;
@property (nonatomic, retain) id timeFrame;
@property (nonatomic, retain) CandleSource *candleSource;
@property (nonatomic, retain) SaveDataSource *saveDataSourceForMain;
@property (nonatomic, retain) SaveDataSource *saveDataSourceForSub;
@property (nonatomic, retain) NSSet *simpleMovingAverageSources;
@end

@interface ChartSource (CoreDataGeneratedAccessors)

- (void)addSimpleMovingAverageSourcesObject:(SimpleMovingAverageSource *)value;
- (void)removeSimpleMovingAverageSourcesObject:(SimpleMovingAverageSource *)value;
- (void)addSimpleMovingAverageSources:(NSSet *)values;
- (void)removeSimpleMovingAverageSources:(NSSet *)values;

@end
