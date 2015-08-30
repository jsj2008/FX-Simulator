//
//  TradeViewController.h
//  ForexGame
//
//  Created  on 2014/06/05.
//  
//

#import <UIKit/UIKit.h>


@class OrderType;

@protocol RatePanelViewControllerDelegate <NSObject>
-(void)didOrder;;
@end

@interface RatePanelViewController : UIViewController
@property (nonatomic, weak) id<RatePanelViewControllerDelegate> delegate;
- (void)order:(OrderType *)orderType;
- (void)updatedSaveData;
@end
