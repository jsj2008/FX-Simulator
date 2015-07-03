//
//  TradeViewController.h
//  ForexGame
//
//  Created  on 2014/05/26.
//  
//
#import <UIKit/UIKit.h>
#import "ChartViewController.h"
#import "NewStartViewController.h"

//#import <UIKit/UIKit.h>
//#import "RatePanelView.h"
//@class RatePanelView;
@class Market;

@interface TradeViewController : UIViewController <ChartViewControllerDelegate, NewStartViewControllerDelegate>
-(void)updatedSaveData;
@end
