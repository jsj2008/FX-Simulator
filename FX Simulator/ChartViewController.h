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
- (void)chartViewTouched;
- (void)longPressedForexData:(ForexHistoryData *)data;
- (void)longPressedEnd;
@end

@class Chart;
@class Market;

@interface ChartViewController : UIViewController
@property (nonatomic, weak) id<ChartViewControllerDelegate> delegate;
- (void)setChart:(Chart *)chart;
- (void)update:(Market *)market;
@end
