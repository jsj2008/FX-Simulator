//
//  NewStartViewController.h
//  FX Simulator
//
//  Created  on 2015/04/26.
//  
//

#import <UIKit/UIKit.h>
//#import "SetNewStartDataViewController.h"

@protocol NewStartViewControllerDelegate <NSObject>
-(void)updatedSaveData;
@end

@interface NewStartViewController : UITableViewController
-(void)addDelegate:(id<NewStartViewControllerDelegate>)delegate;
@property (nonatomic, assign) id<NewStartViewControllerDelegate> delegate;
/*@property (nonatomic, readwrite) Currency *accountCurrency;
@property (nonatomic, readwrite) CurrencyPair *currencyPair;
@property (nonatomic, readwrite) MarketTime *startTime;
@property (nonatomic, readwrite) MarketTimeScale *timeScale;
@property (nonatomic, readwrite) Money *startBalance;
@property (nonatomic, readwrite) Spread *spread;
@property (nonatomic, readwrite) PositionSize *positionSizeOfLot;*/
@end
