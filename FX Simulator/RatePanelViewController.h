//
//  TradeViewController.h
//  ForexGame
//
//  Created  on 2014/06/05.
//  
//

#import <UIKit/UIKit.h>
#import "OrderManager.h"

@class Market;
@class OrderManager;
@class SaveData;

@interface RatePanelViewController : UIViewController <OrderManagerDelegate>
- (void)loadSaveData:(SaveData *)saveData;
- (void)loadMarket:(Market *)market;
- (void)loadOrderManager:(OrderManager *)orderManager;
- (void)update;
@end
