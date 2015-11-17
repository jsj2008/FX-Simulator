//
//  SaveDataBase.h
//  FXSimulator
//
//  Created by yuu on 2015/11/14.
//
//

#import <Foundation/Foundation.h>

@class Currency;
@class CurrencyPair;
@class Time;
@class Lot;
@class Money;
@class PositionSize;
@class Spread;
@class TimeFrame;

@interface SaveDataBase : NSObject
@property (nonatomic) CurrencyPair* currencyPair;
@property (nonatomic) TimeFrame *timeFrame;
@property (nonatomic) Time *startTime;
@property (nonatomic) Spread *spread;
@property (nonatomic) Time *lastLoadedTime;
@property (nonatomic) Currency* accountCurrency;
@property (nonatomic) PositionSize *positionSizeOfLot;
@property (nonatomic) PositionSize *tradePositionSize;
@property (nonatomic) Money *startBalance;
@end
