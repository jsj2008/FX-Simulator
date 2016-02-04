//
//  PositionViewController.h
//  ForexGame
//
//  Created  on 2014/06/06.
//  
//

#import <UIKit/UIKit.h>

@protocol TradeDataViewControllerDelegate <NSObject>
@property (nonatomic, readonly) BOOL isAutoUpdate;
/// 自動更新を設定するボタンが変更されたとき。
- (void)autoUpdateSettingSwitchChanged:(BOOL)isSwitchOn;
@end

@class Market;
@class Result;
@class SaveData;

@interface TradeDataViewController : UIViewController < UITextFieldDelegate>
@property (nonatomic, weak) id<TradeDataViewControllerDelegate> delegate;
- (void)didOrder:(Result *)result;
- (void)loadMarket:(Market *)market;
- (void)loadSaveData:(SaveData *)saveData;
- (void)update;
@end
