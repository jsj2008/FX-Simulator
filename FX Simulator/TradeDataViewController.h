//
//  PositionViewController.h
//  ForexGame
//
//  Created  on 2014/06/06.
//  
//

#import <UIKit/UIKit.h>
#import "RatePanelViewController.h"

@class Equity;

@protocol TradeDataViewControllerDelegate <NSObject>
/// 自動更新を設定するボタンが変更されたとき。
-(void)autoUpdateSettingSwitchChanged:(BOOL)isSwitchOn;
@end

@interface TradeDataViewController : UIViewController <RatePanelViewControllerDelegate, UITextFieldDelegate>
-(void)didOrder;
-(void)tradeViewTouchesBegan;
-(void)updatedSaveData;
@property (nonatomic, weak) id<TradeDataViewControllerDelegate> delegate;
@end
