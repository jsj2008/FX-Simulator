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
@property (nonatomic, readwrite) Lot *defaultInputTradeLot;
@property (nonatomic, readwrite) Lot *inputTradeLot;
@property (nonatomic) PositionSize *positionSizeOfLot;
@end
