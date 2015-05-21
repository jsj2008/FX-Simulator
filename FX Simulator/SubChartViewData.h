//
//  SubChartViewData.h
//  FX Simulator
//
//  Created  on 2014/11/19.
//  
//

#import <Foundation/Foundation.h>

@class MarketTimeScale;

@interface SubChartViewData : NSObject
-(NSArray*)getChartDataArray;
-(NSArray*)getChartDataArrayWithTimeScale:(MarketTimeScale*)timeScale;
-(MarketTimeScale*)toTimeScalefFromSegmentIndex:(int)index;
@property (nonatomic, readonly) NSArray *items;
@end
