//
//  TradeDataViewData.m
//  FX Simulator
//
//  Created  on 2014/12/02.
//  
//

#import "TradeDataViewData.h"

#import "OpenPositionFactory.h"
#import "OpenPosition.h"
#import "EquityFactory.h"
#import "Equity.h"
#import "Money.h"
#import "ForexHistoryData.h"
#import "OrderType.h"
#import "SaveLoader.h"
#import "SaveData.h"
#import "Rate.h"
#import "PositionSize.h"
#import "Lot.h"

@implementation TradeDataViewData {
    SaveData *saveData;
    OpenPosition *openPosition;
    Equity *_equity;
    //int positionSizeOfLot;
    ForexHistoryData *_forexHistoryData;
    Money *_profitAndLoss;
}

-(id)init
{
    if (self = [super init]) {
        openPosition = [OpenPositionFactory createOpenPosition];
        _equity = [EquityFactory createEquity];
        saveData = [SaveLoader load];
        //positionSizeOfLot = saveData.positionSizeOfLot;
    }
    
    return self;
}

-(void)didOrder
{
    [openPosition update];
    [_equity updateBalance];
    
    _profitAndLoss = [openPosition profitAndLossForRate:_forexHistoryData.close];
    [_equity setCurrentProfitAndLoss:_profitAndLoss];
}

-(void)updateForexHistoryData:(ForexHistoryData *)forexHistoryData
{
    _forexHistoryData = forexHistoryData;
    
    _profitAndLoss = [openPosition profitAndLossForRate:_forexHistoryData.close];
    [_equity setCurrentProfitAndLoss:_profitAndLoss];
}

-(NSString*)displayOrderType
{
    return openPosition.orderType.toDisplayString;
}

-(UIColor*)displayOrderTypeColor
{
    return openPosition.orderType.toColor;
}

-(NSString*)displayTotalLot
{
    return openPosition.totalLot.toDisplayString;
    //return [NSString stringWithFormat:@"Lot %@", openPosition.totalLot.stringValue];
}

-(NSString*)displayAverageRate
{
    return [openPosition.averageRate toDisplayString];
}
 
-(NSString*)displayProfitAndLoss
{
    //Money *profitAndLoss = [openPosition profitAndLossForRate:_forexHistoryData.close];
    
    return _profitAndLoss.toDisplayString;
}
 
-(UIColor*)displayProfitAndLossColor
{
    //Money *profitAndLoss = [openPosition profitAndLossForRate:_forexHistoryData.close];
    
    return _profitAndLoss.toDisplayColor;
}

-(NSString*)displayEquity
{
    //Money *profitAndLoss = [openPosition profitAndLossForRate:_forexHistoryData.close];
    
    //[_equity setCurrentProfitAndLoss:profitAndLoss];
    
    return _equity.equity.toDisplayString;
}

-(UIColor*)displayEquityColor
{
    //Money *profitAndLoss = [openPosition profitAndLossForRate:_forexHistoryData.close];
    
    //[_equity setCurrentProfitAndLoss:profitAndLoss];
    
    return _equity.equity.toDisplayColor;
}
 
-(NSString*)displayOpenPositionMarketValue
{
    Money *marketValue = [openPosition marketValueForRate:_forexHistoryData.close];
    
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
