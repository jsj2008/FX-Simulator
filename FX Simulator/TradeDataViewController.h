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
-(void)autoUpdateSettingSwitchChanged:(BOOL)isSwitchOn;
@end

@class Balance;

@protocol TradeDataViewControllerTradeDataDelegate <NSObject>
-(void)updatedBalance:(Balance*)balance;
@end

@interface TradeDataViewController : UIViewController <RatePanelViewControllerDelegate, UITextFieldDelegate>
-(void)didOrder;
-(void)tradeViewTouchesBegan;
@property (nonatomic, weak) id<TradeDataViewControllerDelegate> delegate;
@end
