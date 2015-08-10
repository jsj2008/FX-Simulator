//
//  SaveDataSource+Additions.m
//  FXSimulator
//
//  Created by yuu on 2015/08/08.
//
//

#import "SaveDataSource+Additions.h"

#import "ChartSource.h"
#import "ChartSource+Additions.h"
#import "Setting.h"
#import "FXSTimeRange.h"
#import "MarketTime.h"
#import "TimeFrame.h"
#import "Currency.h"
#import "CurrencyPair.h"
#import "Spread.h"
#import "PositionSize.h"
#import "Lot.h"
#import "Money.h"

@implementation SaveDataSource (Additions)

- (void)setDefaultDataAndSlotNumber:(NSUInteger)slotNumber
{
    self.fxsSlotNumber = slotNumber;
    self.fxsCurrencyPair = [[CurrencyPair alloc] initWithBaseCurrency:[[Currency alloc] initWithCurrencyType:USD] QuoteCurrency:[[Currency alloc] initWithCurrencyType:JPY]];
    self.fxsTimeFrame = [[TimeFrame alloc] initWithMinute:15];
    self.fxsStartTime = [Setting rangeForCurrencyPair:self.currencyPair timeScale:self.timeFrame].start;
    self.fxsLastLoadedTime = self.fxsStartTime;
    self.fxsSpread = [[Spread alloc] initWithPips:1 currencyPair:self.currencyPair];
    self.fxsAccountCurrency = [[Currency alloc] initWithCurrencyType:JPY];
    self.fxsStartBalance = [[Money alloc] initWithAmount:1000000 currency:self.accountCurrency];
    self.fxsPositionSizeOfLot = [[PositionSize alloc] initWithSizeValue:10000];
    self.fxsTradePositionSize = [[PositionSize alloc] initWithSizeValue:10000];
    self.fxsIsAutoUpdate = YES;
    self.fxsAutoUpdateIntervalSeconds = 1.0;
}

- (void)setDefaultChartSources:(NSManagedObjectContext *)managedObjectContext
{
    ChartSource *mainChartSource = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([ChartSource class]) inManagedObjectContext:managedObjectContext];
    mainChartSource.fxsChartIndex = 0;
    mainChartSource.fxsCurrencyPair = self.fxsCurrencyPair;
    mainChartSource.fxsTimeFrame = self.timeFrame;
    mainChartSource.fxsIsSelected = YES;
    
    [self addMainChartSourcesObject:mainChartSource];
    
}

#pragma mark - getter,setter

- (void)setFxsSlotNumber:(NSUInteger)fxsSlotNumber
{
    self.slotNumber = (int)fxsSlotNumber;
}

- (NSUInteger)fxsSlotNumber
{
    return self.slotNumber;
}

- (void)setFxsCurrencyPair:(CurrencyPair *)fxsCurrencyPair
{
    self.currencyPair = fxsCurrencyPair;
}

- (CurrencyPair *)fxsCurrencyPair
{
    return self.currencyPair;
}

- (void)setFxsTimeFrame:(TimeFrame *)fxsTimeFrame
{
    self.timeFrame = fxsTimeFrame;
}

- (TimeFrame *)fxsTimeFrame
{
    return self.timeFrame;
}

- (void)setFxsStartTime:(MarketTime *)fxsStartTime
{
    self.startTime = fxsStartTime;
}

- (MarketTime *)fxsStartTime
{
    return self.startTime;
}

- (void)setFxsSpread:(Spread *)fxsSpread
{
    self.spread = fxsSpread;
}

- (Spread *)fxsSpread
{
    return self.spread;
}

- (void)setFxsLastLoadedTime:(MarketTime *)fxsLastLoadedTime
{
    self.lastLoadedTime = fxsLastLoadedTime;
}

- (MarketTime *)fxsLastLoadedTime
{
    return self.lastLoadedTime;
}

- (void)setFxsAccountCurrency:(Currency *)fxsAccountCurrency
{
    self.accountCurrency = fxsAccountCurrency;
}

- (Currency *)fxsAccountCurrency
{
    return self.accountCurrency;
}

- (void)setFxsPositionSizeOfLot:(PositionSize *)fxsPositionSizeOfLot
{
    self.positionSizeOfLot = fxsPositionSizeOfLot;
}

- (PositionSize *)fxsPositionSizeOfLot
{
    return self.positionSizeOfLot;
}

- (void)setFxsTradePositionSize:(PositionSize *)fxsTradePositionSize
{
    self.tradePositionSize = fxsTradePositionSize;
}

- (PositionSize *)fxsTradePositionSize
{
    return self.tradePositionSize;
}

- (void)setFxsStartBalance:(Money *)fxsStartBalance
{
    self.startBalance = fxsStartBalance;
}

- (Money *)fxsStartBalance
{
    return self.startBalance;
}

- (void)setFxsIsAutoUpdate:(BOOL)fxsIsAutoUpdate
{
    self.isAutoUpdate = fxsIsAutoUpdate;
}

- (BOOL)fxsIsAutoUpdate
{
    return self.isAutoUpdate;
}

- (void)setFxsAutoUpdateIntervalSeconds:(float)fxsAutoUpdateIntervalSeconds
{
    self.autoUpdateIntervalSeconds = fxsAutoUpdateIntervalSeconds;
}

- (float)fxsAutoUpdateIntervalSeconds
{
    return self.autoUpdateIntervalSeconds;
}

@end
