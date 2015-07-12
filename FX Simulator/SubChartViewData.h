//
//  SubChartViewData.h
//  FX Simulator
//
//  Created  on 2014/11/19.
//  
//

#import <Foundation/Foundation.h>

@class ForexDataChunk;
@class MarketTimeScale;

@interface SubChartViewData : NSObject
- (ForexDataChunk *)getCurrentChunk;
//-(NSArray*)getChartDataArrayWithTimeScale:(MarketTimeScale*)timeScale;
-(MarketTimeScale*)toTimeScalefFromSegmentIndex:(int)index;
@property (nonatomic, readonly) NSArray *items;
@end
