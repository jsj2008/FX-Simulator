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
/// 資産が更新されたとき。
-(void)updatedEquity:(Equity*)equity;
@end

@interface TradeDataViewController : UIViewController <RatePanelViewControllerDelegate, UITextFieldDelegate>
-(void)didOrder;
-(void)tradeViewTouchesBegan;
@property (nonatomic, weak) id<TradeDataViewControllerDelegate> delegate;
@end
