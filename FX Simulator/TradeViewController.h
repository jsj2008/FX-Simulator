//
//  TradeViewController.h
//  ForexGame
//
//  Created  on 2014/05/26.
//  
//
#import <UIKit/UIKit.h>
#import "ChartViewController.h"
#import "TradeDataViewController.h"
//#import <UIKit/UIKit.h>
//#import "RatePanelView.h"
//@class RatePanelView;
@class Market;

@interface TradeViewController : UIViewController <ChartViewControllerDelegate, TradeDataViewControllerDelegate>
//-(void)chartViewTouched;
-(void)autoUpdateSettingSwitchChanged:(BOOL)isSwitchOn;
//@property (nonatomic, readonly) Market *market;
@end
