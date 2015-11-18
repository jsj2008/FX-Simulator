//
//  ChartSource.h
//  FXSimulator
//
//  Created by yuu on 2015/11/18.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BollingerBandsSource, CandleSource, HeikinAshiSource, MovingAverageSource, SaveDataSource;

@interface ChartSource : NSManagedObject

@property (nonatomic) int32_t chartIndex;
@property (nonatomic, retain) id currencyPair;
@property (nonatomic) int32_t displayDataCount;
@property (nonatomic) BOOL isDisplay;
@property (nonatomic, retain) id timeFrame;
@property (nonatomic, retain) CandleSource *candleSource;
@property (nonatomic, retain) SaveDataSource *saveDataSourceForMain;
@property (nonatomic, retain) SaveDataSource *saveDataSourceForSub;
@property (nonatomic, retain) NSSet *movingAverageSources;
@property (nonatomic, retain) NSSet *bollingerBandsSources;
@property (nonatomic, retain) NSSet *heikinAshiSources;
@end

@interface ChartSource (CoreDataGeneratedAccessors)

- (void)addMovingAverageSourcesObject:(MovingAverageSource *)value;
- (void)removeMovingAverageSourcesObject:(MovingAverageSource *)value;
- (void)addMovingAverageSources:(NSSet *)values;
- (void)removeMovingAverageSources:(NSSet *)values;

- (void)addBollingerBandsSourcesObject:(BollingerBandsSource *)value;
- (void)removeBollingerBandsSourcesObject:(BollingerBandsSource *)value;
- (void)addBollingerBandsSources:(NSSet *)values;
- (void)removeBollingerBandsSources:(NSSet *)values;

- (void)addHeikinAshiSourcesObject:(HeikinAshiSource *)value;
- (void)removeHeikinAshiSourcesObject:(HeikinAshiSource *)value;
- (void)addHeikinAshiSources:(NSSet *)values;
- (void)removeHeikinAshiSources:(NSSet *)values;

@end
