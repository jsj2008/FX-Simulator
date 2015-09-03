//
//  SubChartDataViewController.h
//  FX Simulator
//
//  Created  on 2015/04/03.
//  
//

#import <UIKit/UIKit.h>

@class ForexHistoryData;

@interface SubChartDataViewController : UIViewController
- (void)displayForexHistoryData:(ForexHistoryData *)forexHistoryData;
- (void)hiddenForexHistoryData;
@end
