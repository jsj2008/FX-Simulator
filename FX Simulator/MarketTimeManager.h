//
//  MarketTime.h
//  FX Simulator
//
//  Created  on 2014/11/19.
//  
//

#import <Foundation/Foundation.h>

@interface MarketTimeManager : NSObject
@property (nonatomic, readonly) int currentLoadedRowid;
@property (nonatomic, readwrite) NSNumber *autoUpdateInterval;
- (void)addObserver:(NSObject *)observer;
- (void)start;
- (void)end;
- (void)add;
- (void)pause;
- (void)resume;
@end
