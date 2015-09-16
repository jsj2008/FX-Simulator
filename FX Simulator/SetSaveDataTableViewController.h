//
//  SetSaveDataTableViewController.h
//  FXSimulator
//
//  Created by yuu on 2015/09/14.
//
//

#import <UIKit/UIKit.h>

@class Currency;
@class CurrencyPair;
@class Money;
@class PositionSize;
@class Spread;
@class Time;
@class TimeFrame;

@interface SetSaveDataTableViewController : UITableViewController
@property (nonatomic) CurrencyPair *currencyPair;
@property (nonatomic) Time *startTime;
@property (nonatomic) TimeFrame *timeFrame;
@property (nonatomic) Spread *spread;
@property (nonatomic) Currency *accountCurrency;
@property (nonatomic) Money *startBalance;
@property (nonatomic) PositionSize *positionSizeOfLot;
@end
