//
//  PositionViewController.h
//  ForexGame
//
//  Created  on 2014/06/06.
//  
//

#import <UIKit/UIKit.h>
#import "RatePanelViewController.h"

@protocol TradeDataViewControllerDelegate <NSObject>
/// 自動更新を設定するボタンが変更されたとき。
-(void)autoUpdateSettingSwitchChanged:(BOOL)isSwitchOn;
@end

@interface TradeDataViewController : UIViewController <RatePanelViewControllerDelegate, UITextFieldDelegate>
@property (nonatomic, weak) id<TradeDataViewControllerDelegate> delegate;
-(void)didOrder;
-(void)tradeViewTouchesBegan;
-(void)updatedSaveData;
@end
