//
//  TradeDataViewData.m
//  FX Simulator
//
//  Created  on 2014/12/02.
//  
//

#import "TradeDataViewData.h"

#import "Account.h"
#import "OpenPositionFactory.h"
#import "OpenPosition.h"
#import "Money.h"
#import "ForexHistoryData.h"
#import "OrderType.h"
#import "SaveLoader.h"
#import "SaveData.h"
#import "Rate.h"
#import "PositionSize.h"
#import "Lot.h"


@implementation TradeDataViewData {
    Account *_account;
    Money *_equity;
    SaveData *saveData;
    OpenPosition *openPosition;
    Money *_profitAndLoss;
    ForexHistoryData *_forexHistoryData;
}

-(id)init
{
    if (self = [super init]) {
        openPosition = [OpenPositionFactory createOpenPosition];
        _account = [Account sharedAccount];
        _equity = _account.equity;
        saveData = [SaveLoader load];
        //positionSizeOfLot = saveData.positionSizeOfLot;
    }
    
    return self;
}

-(void)didOrder
{
    _profitAndLoss = [openPosition profitAndLossForRate:_forexHistoryData.close];
    
    [_account didOrder];
}

-(void)updateForexHistoryData:(ForexHistoryData *)forexHistoryData
{
    _forexHistoryData = forexHistoryData;
    
    _profitAndLoss = [openPosition profitAndLossForRate:_forexHistoryData.close];
    
    _equity = _account.equity;
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
    
    return _equity.toDisplayString;
}

-(UIColor*)displayEquityColor
{
    //Money *profitAndLoss = [openPosition profitAndLossForRate:_forexHistoryData.close];
    
    //[_equity setCurrentProfitAndLoss:profitAndLoss];
    
    return _equity.toDisplayColor;
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
