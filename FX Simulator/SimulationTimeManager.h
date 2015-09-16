//
//  MarketTime.h
//  FX Simulator
//
//  Created  on 2014/11/19.
//  
//

#import <Foundation/Foundation.h>

@interface SimulationTimeManager : NSObject
@property (nonatomic, readonly) int currentLoadedRowid;
@property (nonatomic, readonly) BOOL isStart;
- (instancetype)initWithAutoUpdateIntervalSeconds:(float)autoUpdateIntervalSeconds isAutoUpdate:(BOOL)isAutoUpdate;
- (void)setAutoUpdateIntervalSeconds:(float)autoUpdateIntervalSeconds;
- (void)setIsAutoUpdate:(BOOL)isAutoUpdate;
- (void)addObserver:(NSObject *)observer;
- (void)start;
- (void)end;
- (void)add;
- (void)pause;
- (void)resume;
@end
