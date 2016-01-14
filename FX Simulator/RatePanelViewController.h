//
//  TradeViewController.h
//  ForexGame
//
//  Created  on 2014/06/05.
//  
//

#import <UIKit/UIKit.h>

@class Market;
@class OrderFactory;
@class OrderManager;
@class SaveData;

@interface RatePanelViewController : UIViewController
- (void)loadSaveData:(SaveData *)saveData;
- (void)loadMarket:(Market *)market;
- (void)loadOrderFactory:(OrderFactory *)orderFactory;
- (void)loadOrderManager:(OrderManager *)orderManager;
- (void)update;
@end
