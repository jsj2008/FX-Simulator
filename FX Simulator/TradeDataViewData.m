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
#import "OrderType.h"
#import "SaveLoader.h"
#import "SaveData.h"
#import "SimulationManager.h"
#import "Rate.h"
#import "PositionSize.h"
#import "Lot.h"


@implementation TradeDataViewData {
    SaveData *saveData;
    SimulationManager *_simulationManager;
    Rate *_currentRate;
}

-(id)init
{
    if (self = [super init]) {
        _simulationManager = [SimulationManager sharedSimulationManager];
        saveData = [SaveLoader load];
    }
    
    return self;
}

-(void)didOrder
{
    [_simulationManager didOrder];
}

-(void)updateFromCurrentRate:(Rate *)currentRate
{
    _currentRate = currentRate;
}

-(NSString*)displayCurrentSetting
{
    NSString *str = [NSString stringWithFormat:@"%@ %@", [saveData.currencyPair toDisplayString], [saveData.timeFrame toDisplayString]];
    
    return str;
}

-(NSString*)displayOrderType
{
    return _simulationManager.account.openPosition.orderType.toDisplayString;
}

-(UIColor*)displayOrderTypeColor
{
    return _simulationManager.account.openPosition.orderType.toColor;
}

-(NSString*)displayTotalLot
{
    return _simulationManager.account.openPosition.totalLot.toDisplayString;
    //return [NSString stringWithFormat:@"Lot %@", openPosition.totalLot.stringValue];
}

-(NSString*)displayAverageRate
{
    return [_simulationManager.account.openPosition.averageRate toDisplayString];
}
 
-(NSString*)displayProfitAndLoss
{
    //Money *profitAndLoss = [openPosition profitAndLossForRate:_forexHistoryData.close];
    
    return _simulationManager.account.profitAndLoss.toDisplayString;
}
 
-(UIColor*)displayProfitAndLossColor
{
    //Money *profitAndLoss = [openPosition profitAndLossForRate:_forexHistoryData.close];
    
    return _simulationManager.account.profitAndLoss.toDisplayColor;
}

-(NSString*)displayEquity
{
    //Money *profitAndLoss = [openPosition profitAndLossForRate:_forexHistoryData.close];
    
    //[_equity setCurrentProfitAndLoss:profitAndLoss];
    
    return _simulationManager.account.equity.toDisplayString;
}

-(UIColor*)displayEquityColor
{
    //Money *profitAndLoss = [openPosition profitAndLossForRate:_forexHistoryData.close];
    
    //[_equity setCurrentProfitAndLoss:profitAndLoss];
    
    return _simulationManager.account.equity.toDisplayColor;
}
 
-(NSString*)displayOpenPositionMarketValue
{
    Money *marketValue = [_simulationManager.account.openPosition marketValueForRate:_currentRate];
    
    return marketValue.toDisplayString;
}

-(void)setTradeLot:(Lot *)tradeLot
{
    saveData.tradePositionSize = [tradeLot toPositionSize];
}

-(Lot*)tradeLot
{
    return [saveData.tradePositionSize toLot];
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
    return saveData.isAutoUpdate;
}

-(void)setIsAutoUpdate:(BOOL)isAutoUpdate
{
    saveData.isAutoUpdate = isAutoUpdate;
}

@end
