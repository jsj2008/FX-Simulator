//
//  NewStartViewController.h
//  FX Simulator
//
//  Created  on 2015/04/26.
//  
//

#import <UIKit/UIKit.h>

@class Currency;
@class CurrencyPair;
@class MarketTime;
@class MarketTimeScale;
@class Money;
@class PositionSize;
@class Spread;

@protocol NewStartViewControllerDelegate <NSObject>
@property (nonatomic, readwrite) Currency *accountCurrency;
@property (nonatomic, readwrite) CurrencyPair *currencyPair;
@property (nonatomic, readwrite) MarketTime *startTime;
@property (nonatomic, readwrite) MarketTimeScale *timeScale;
@property (nonatomic, readwrite) Money *startBalance;
@property (nonatomic, readwrite) Spread *spread;
/// 1LotあたりのPositionSize
@property (nonatomic, readwrite) PositionSize *positionSizeOfLot;
@end

@interface NewStartViewController : UITableViewController <NewStartViewControllerDelegate>
@property (nonatomic, readwrite) Currency *accountCurrency;
@property (nonatomic, readwrite) CurrencyPair *currencyPair;
@property (nonatomic, readwrite) MarketTime *startTime;
@property (nonatomic, readwrite) MarketTimeScale *timeScale;
@property (nonatomic, readwrite) Money *startBalance;
@property (nonatomic, readwrite) Spread *spread;
@property (nonatomic, readwrite) PositionSize *positionSizeOfLot;
@end
