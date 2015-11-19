//
//  ChartSource.h
//  FXSimulator
//
//  Created by yuu on 2015/11/19.
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
@property (nonatomic, retain) id type;
@property (nonatomic, retain) NSSet *bollingerBandsSources;
@property (nonatomic, retain) CandleSource *candleSource;
@property (nonatomic, retain) NSSet *heikinAshiSources;
@property (nonatomic, retain) NSSet *movingAverageSources;
@property (nonatomic, retain) SaveDataSource *saveDataSource;
@end

@interface ChartSource (CoreDataGeneratedAccessors)

- (void)addBollingerBandsSourcesObject:(BollingerBandsSource *)value;
- (void)removeBollingerBandsSourcesObject:(BollingerBandsSource *)value;
- (void)addBollingerBandsSources:(NSSet *)values;
- (void)removeBollingerBandsSources:(NSSet *)values;

- (void)addHeikinAshiSourcesObject:(HeikinAshiSource *)value;
- (void)removeHeikinAshiSourcesObject:(HeikinAshiSource *)value;
- (void)addHeikinAshiSources:(NSSet *)values;
- (void)removeHeikinAshiSources:(NSSet *)values;

- (void)addMovingAverageSourcesObject:(MovingAverageSource *)value;
- (void)removeMovingAverageSourcesObject:(MovingAverageSource *)value;
- (void)addMovingAverageSources:(NSSet *)values;
- (void)removeMovingAverageSources:(NSSet *)values;

@end
