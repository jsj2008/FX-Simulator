//
//  PositionViewController.h
//  ForexGame
//
//  Created  on 2014/06/06.
//  
//

#import <UIKit/UIKit.h>
#import "OrderManager.h"

@protocol TradeDataViewControllerDelegate <NSObject>
/// 自動更新を設定するボタンが変更されたとき。
- (void)autoUpdateSettingSwitchChanged:(BOOL)isSwitchOn;
@end

@class Market;
@class OrderResult;
@class SaveData;

@interface TradeDataViewController : UIViewController < UITextFieldDelegate, OrderManagerDelegate>
@property (nonatomic, weak) id<TradeDataViewControllerDelegate> delegate;
- (void)didOrder:(OrderResult *)result;
- (void)loadMarket:(Market *)market;
- (void)loadSaveData:(SaveData *)saveData;
- (void)update;
- (void)tradeViewTouchesBegan;
@end
