//
//  MarketTime.h
//  FX Simulator
//
//  Created  on 2014/11/19.
//  
//

#import <Foundation/Foundation.h>

/*@protocol MarketTime <NSObject>
-(void)addObserver:(NSObject*)observer;
-(void)start;
@property (nonatomic) BOOL paused;
@property (nonatomic) int time;
@end*/

@interface MarketTimeManager : NSObject
-(void)addObserver:(NSObject*)observer;
-(void)start;
-(void)add;
-(void)pause;
-(void)resume;
//@property (nonatomic) BOOL isAutoUpdate;
@property (nonatomic, readonly) int currentLoadedRowid;
@property (nonatomic, readwrite) NSNumber *autoUpdateInterval;
@end
