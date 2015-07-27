//
//  SubChartViewData.h
//  FX Simulator
//
//  Created  on 2014/11/19.
//  
//

#import <Foundation/Foundation.h>

@class ForexDataChunk;
@class TimeFrame;

@interface SubChartViewData : NSObject
- (ForexDataChunk *)getCurrentChunk;
- (void)updateSelectedIndex:(NSUInteger)newIndex;
@property (nonatomic, readonly) NSArray *items;
@property (nonatomic) NSUInteger selectedSegmentIndex;
@property (nonatomic, readonly) TimeFrame *selectedTimeScale;
@end
