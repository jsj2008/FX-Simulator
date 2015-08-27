//
//  TradeViewController.h
//  ForexGame
//
//  Created  on 2014/06/05.
//  
//

#import <UIKit/UIKit.h>

@class ForexHistoryData;

@protocol ChartViewControllerDelegate <NSObject>
@optional
-(void)chartViewTouched;
- (void)longPressedForexData:(ForexHistoryData *)data;
- (void)longPressedEnd;
@end

@class Chart;
@class ForexDataChunk;
@class MarketTime;

@interface ChartViewController : UIViewController
- (void)setChart:(Chart *)chart;
- (void)updateChartForTime:(MarketTime *)time;
- (void)updatedSaveData;
+ (NSUInteger)requireForexDataCountForChart;
@property (nonatomic, weak) id<ChartViewControllerDelegate> delegate;
@end
