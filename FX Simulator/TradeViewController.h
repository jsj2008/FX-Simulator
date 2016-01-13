//
//  TradeViewController.h
//  ForexGame
//
//  Created  on 2014/05/26.
//  
//
#import <UIKit/UIKit.h>
#import "ChartViewController.h"
#import "OrderManager.h"
#import "SimulationManager.h"
#import "TradeDataViewController.h"

@interface TradeViewController : UIViewController <ChartViewControllerDelegate, SimulationManagerDelegate, TradeDataViewControllerDelegate>

@end
