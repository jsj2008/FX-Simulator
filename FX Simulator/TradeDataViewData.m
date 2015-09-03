//
//  TradeDataViewData.m
//  FX Simulator
//
//  Created  on 2014/12/02.
//  
//

#import "TradeDataViewData.h"

#import "Account.h"
#import "CurrencyPair.h"
#import "OpenPosition.h"
#import "Money.h"
#import "ForexHistoryData.h"
#import "TimeFrame.h"
#import "PositionType.h"
#import "SaveLoader.h"
#import "SaveData.h"
#import "SimulationManager.h"
#import "Rate.h"
#import "Rates.h"
#import "PositionSize.h"
#import "Lot.h"


@implementation TradeDataViewData {
    SaveData *_saveData;
    SimulationManager *_simulationManager;
}

-(id)init
{
    if (self = [super init]) {
        _simulationManager = [SimulationManager sharedSimulationManager];
        _saveData = [SaveLoader load];
    }
    
    return self;
}

-(NSString*)displayCurrentSetting
{
    NSString *str = [NSString stringWithFormat:@"%@ %@", [_saveData.currencyPair toDisplayString], [_saveData.timeFrame toDisplayString]];
    
    return str;
}

-(NSString*)displayOrderType
{
    return [_saveData.account.orderType toDisplayString];
}

-(UIColor*)displayOrderTypeColor
{
    return [_saveData.account.orderType toColor];
}

-(NSString*)displayTotalLot
{
    return [_saveData.account.totalLot toDisplayString];
}

-(NSString*)displayAverageRate
{
    return [_saveData.account.averageRate toDisplayString];
}
 
-(NSString*)displayProfitAndLoss
{
    return _saveData.account.profitAndLoss.toDisplayString;
}
 
-(UIColor*)displayProfitAndLossColor
{
    return _saveData.account.profitAndLoss.toDisplayColor;
}

-(NSString*)displayEquity
{
    return _saveData.account.equity.toDisplayString;
}

- (UIColor *)displayEquityColor
{
    return _saveData.account.equity.toDisplayColor;
}

- (void)setTradeLot:(Lot *)tradeLot
{
    _saveData.tradePositionSize = [tradeLot toPositionSize];
}

- (Lot *)tradeLot
{
    return [_saveData.tradePositionSize toLot];
}

/*-(NSString*)defaultTradeLotInputFieldValue
{
    return [[saveData.tradePositionSize toLot] toDisplayString];
}

-(void)setTradeLotInputFieldValue:(NSString *)tradeLotInputFieldValue
{
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    
    Lot *lot = [[Lot alloc] initWithLotValue:[[formatter numberFromString:tradeLotInputFieldValue] unsignedLongLongValue]];
    
    saveData.tradePositionSize = [lot toPositionSize];
}

-(NSString*)tradeLotInputFieldValue
{
    return [[saveData.tradePositionSize toLot] toDisplayString];
}*/

-(BOOL)isAutoUpdate
{
    return _saveData.isAutoUpdate;
}

-(void)setIsAutoUpdate:(BOOL)isAutoUpdate
{
    _saveData.isAutoUpdate = isAutoUpdate;
}

@end
