//
//  InputTradeLotViewController.h
//  FX Simulator
//
//  Created  on 2015/03/24.
//  
//

#import <UIKit/UIKit.h>

@class Lot;
@class PositionSize;

@interface InputTradeLotViewController : UIViewController
@property (nonatomic) PositionSize *tradePositionSize;
@property (nonatomic) PositionSize *positionSizeOfLot;
- (void)setDefaultTradePositionSize:(PositionSize *)positionSize;
@end
