//
//  SaveDataBase.m
//  FXSimulator
//
//  Created by yuu on 2015/11/14.
//
//

#import "SaveDataBase.h"

#import "FXSComparisonResult.h"
#import "Money.h"
#import "PositionSize.h"
#import "Setting.h"
#import "Spread.h"

@implementation SaveDataBase

- (void)setCurrencyPair:(CurrencyPair *)currencyPair
{
    if (!currencyPair) {
        return;
    }
    
    _currencyPair = currencyPair;
}

- (void)setTimeFrame:(TimeFrame *)timeFrame
{
    if (!timeFrame) {
        return;
    }
    
    _timeFrame = timeFrame;
}

- (void)setStartTime:(Time *)startTime
{
    if (!startTime) {
        return;
    }
    
    _startTime = startTime;
}

- (void)setSpread:(Spread *)spread
{
    if (!spread) {
        return;
    }
    
    Spread *maxSpread = [Setting maxSpread];
    FXSComparisonResult *resultMax = [maxSpread compareSpread:spread];
    
    Spread *minSpread = [Setting minSpread];
    FXSComparisonResult *resultMin = [minSpread compareSpread:spread];
    
    if (!resultMax || !resultMin) {
        return;
    }
    
    if (resultMax.result == NSOrderedAscending) {
        spread = [[Spread alloc] initWithPips:maxSpread.spreadValue currencyPair:spread.currencyPair];
    } else if (resultMin.result == NSOrderedDescending) {
        spread = [[Spread alloc] initWithPips:minSpread.spreadValue currencyPair:spread.currencyPair];
    }
    
    _spread = spread;
}

- (void)setAccountCurrency:(Currency *)accountCurrency
{
    if (!accountCurrency) {
        return;
    }
    
    _accountCurrency = accountCurrency;
}

- (void)setPositionSizeOfLot:(PositionSize *)positionSizeOfLot
{
    if (!positionSizeOfLot) {
        return;
    }
    
    _positionSizeOfLot = positionSizeOfLot;
}

- (void)setTradePositionSize:(PositionSize *)tradePositionSize
{
    if (!tradePositionSize) {
        return;
    }
    
    PositionSize *maxTradePositionSize = [Setting maxTradePositionSize];
    NSComparisonResult resultMax = [maxTradePositionSize comparePositionSize:tradePositionSize];
    
    if (resultMax == NSOrderedAscending) {
        tradePositionSize = maxTradePositionSize;
    }
    
    PositionSize *minTradePositionSize = self.positionSizeOfLot;
    NSComparisonResult resultMin = [minTradePositionSize comparePositionSize:tradePositionSize];
    
    if (resultMin == NSOrderedDescending) {
        tradePositionSize = minTradePositionSize;
    }
    
    _tradePositionSize = tradePositionSize;
}

- (void)setStartBalance:(Money *)startBalance
{
    if (!startBalance) {
        return;
    }
    
    Money *maxStartBalance = [Setting maxStartBalance];
    FXSComparisonResult *resultMax = [maxStartBalance compareMoney:startBalance];
    
    Money *minStartBalance = [Setting minStartBalance];
    FXSComparisonResult *resultMin = [minStartBalance compareMoney:startBalance];
    
    if (!maxStartBalance || !minStartBalance) {
        return;
    }
    
    if (resultMax.result == NSOrderedAscending) {
        startBalance = [[Money alloc] initWithAmount:maxStartBalance.amount currency:startBalance.currency];
    } else if (resultMin.result == NSOrderedDescending) {
        startBalance = [[Money alloc] initWithAmount:minStartBalance.amount currency:startBalance.currency];
    }
    
    _startBalance = startBalance;
}

@end
