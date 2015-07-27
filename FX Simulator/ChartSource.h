//
//  ChartSource.h
//  FXSimulator
//
//  Created by yuu on 2015/07/27.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CandleSource, NSManagedObject, SimpleMovingAverageSource;

@interface ChartSource : NSManagedObject

@property (nonatomic) int32_t chartIndex;
@property (nonatomic, retain) id currencyPair;
@property (nonatomic) BOOL isSelected;
@property (nonatomic, retain) id timeFrame;
@property (nonatomic, retain) CandleSource *candleSource;
@property (nonatomic, retain) NSManagedObject *saveDataSourceForMain;
@property (nonatomic, retain) NSManagedObject *saveDataSourceForSub;
@property (nonatomic, retain) NSSet *simpleMovingAverageSources;
@end

@interface ChartSource (CoreDataGeneratedAccessors)

- (void)addSimpleMovingAverageSourcesObject:(SimpleMovingAverageSource *)value;
- (void)removeSimpleMovingAverageSourcesObject:(SimpleMovingAverageSource *)value;
- (void)addSimpleMovingAverageSources:(NSSet *)values;
- (void)removeSimpleMovingAverageSources:(NSSet *)values;

@end
