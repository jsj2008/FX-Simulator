//
//  SaveData.m
//  FX Simulator
//
//  Created  on 2014/10/08.
//  
//

#import "SaveData.h"

#import "MarketTime.h"
#import "MarketTimeScale.h"
#import "Currency.h"
#import "CurrencyPair.h"
#import "TableNameFormatter.h"
#import "Spread.h"
#import "PositionSize.h"
#import "Lot.h"
#import "Money.h"
#import "TradeDbDataSource.h"

@implementation SaveData

-(id)initWithSaveDataDictionary:(NSDictionary*)dic
{
    if (self = [super init]) {
        Currency *baseCurrency = [[Currency alloc] initWithString:[[dic objectForKey:@"CurrencyPair"] objectAtIndex:0]];
        Currency *quoteCurrency = [[Currency alloc] initWithString:[[dic objectForKey:@"CurrencyPair"] objectAtIndex:1]];
        
        _slotNumber = [[dic objectForKey:@"SaveSlot"] intValue];
        _currencyPair = [[CurrencyPair alloc] initWithBaseCurrency:baseCurrency QuoteCurrency:quoteCurrency];
        _timeScale = [[MarketTimeScale alloc] initWithMinute:[[dic objectForKey:@"TimeScale"] intValue]];
        _startTime = [[MarketTime alloc] initWithTimestamp:[[dic objectForKey:@"StartTimestamp"] intValue]];
        _spread = [[Spread alloc] initWithPips:[[dic objectForKey:@"Spread"] doubleValue] currencyPair:_currencyPair];
        _accountCurrency = [dic objectForKey:@"AccountCurrency"];
        _startBalance = [[Money alloc] initWithAmount:[[dic objectForKey:@"StartBalance"] longLongValue] currency:_accountCurrency];
        _positionSizeOfLot = [[PositionSize alloc] initWithSizeValue:[[dic objectForKey:@"PositionSizeOfLot"] unsignedLongLongValue]];
        //_defaultTradePositionSize = [[PositionSize alloc] initWithSizeValue:[[dic objectForKey:@"DefaultTradePositionSize"] unsignedLongLongValue]];
        _tradePositionSize = [[PositionSize alloc] initWithSizeValue:[[dic objectForKey:@"TradePositionSize"] unsignedLongLongValue]];
        //_lot = [[Lot alloc] initWithLotValue:[[dic objectForKey:@"Lot"] unsignedLongLongValue]];
        _lastLoadedCloseTimestamp = [[MarketTime alloc] initWithTimestamp:[[dic objectForKey:@"LastLoadedCloseTimestamp"] intValue]];
        _isAutoUpdate = [[dic objectForKey:@"IsAutoUpdate"] boolValue];
        _autoUpdateInterval = [NSNumber numberWithFloat:[[dic objectForKey:@"AutoUpdateInterval"] floatValue]];
        _subChartSelectedTimeScale = [[MarketTimeScale alloc] initWithMinute:[[dic objectForKey:@"SubChartSelectedTimeScale"] intValue]];
        
        _orderHistoryDataSource = [[TradeDbDataSource alloc] initWithTableName:[dic objectForKey:@"OrderHistoryTableName"] SaveSlotNumber:[NSNumber numberWithInt:_slotNumber]];
        _executionHistoryDataSource = [[TradeDbDataSource alloc] initWithTableName:[dic objectForKey:@"ExecutionHistoryTableName"] SaveSlotNumber:[NSNumber numberWithInt:_slotNumber]];
        _openPositionDataSource = [[TradeDbDataSource alloc] initWithTableName:[dic objectForKey:@"OpenPositionTableName"] SaveSlotNumber:[NSNumber numberWithInt:_slotNumber]];
    }
    
    return self;
}

-(id)initWithDefaultDataAndSlotNumber:(int)slotNumber
{
    if (self = [super init]) {
        _slotNumber = slotNumber;
        _currencyPair = [[CurrencyPair alloc] initWithBaseCurrency:[[Currency alloc] initWithCurrencyType:USD] QuoteCurrency:[[Currency alloc] initWithCurrencyType:JPY]];
        _timeScale = [[MarketTimeScale alloc] initWithMinute:15];
        NSDateFormatter *formatter = [NSDateFormatter new];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date = [formatter dateFromString:@"2010-01-01 00:00:00"];
        _startTime = [[MarketTime alloc] initWithTimestamp:[date timeIntervalSince1970]];
        _spread = [[Spread alloc] initWithPips:1 currencyPair:_currencyPair];
        _accountCurrency = [[Currency alloc] initWithCurrencyType:JPY];
        _startBalance = [[Money alloc] initWithAmount:1000000 currency:_accountCurrency];
        _positionSizeOfLot = [[PositionSize alloc] initWithSizeValue:10000];
        //_defaultTradePositionSize = [[PositionSize alloc] initWithSizeValue:10000];
        _tradePositionSize = [[PositionSize alloc] initWithSizeValue:10000];
        //_lot = [[Lot alloc] initWithLotValue:1];
        _lastLoadedCloseTimestamp = 0;
        _isAutoUpdate = YES;
        _autoUpdateInterval = @1.0;
        _subChartSelectedTimeScale = [[MarketTimeScale alloc] initWithMinute:60];
        
        NSString *orderHistoryTableName = @"order_history";
        NSString *executionHistoryTableName = @"execution_history";
        NSString *openPositionTableName = @"open_position";
        /*NSString *orderHistoryTableName = [TableNameFormatter orderHistoryTableNameForSaveSlot:_slotNumber];
        NSString *executionHistoryTableName = [TableNameFormatter executionHistoryTableNameForSaveSlot:_slotNumber];
        NSString *openPositionTableName = [TableNameFormatter openPositionTableNameForSaveSlot:_slotNumber];*/
        
        _orderHistoryDataSource = [[TradeDbDataSource alloc] initWithTableName:orderHistoryTableName SaveSlotNumber:[NSNumber numberWithInt:slotNumber]];
        _executionHistoryDataSource = [[TradeDbDataSource alloc] initWithTableName:executionHistoryTableName SaveSlotNumber:[NSNumber numberWithInt:slotNumber]];
        _openPositionDataSource = [[TradeDbDataSource alloc] initWithTableName:openPositionTableName SaveSlotNumber:[NSNumber numberWithInt:slotNumber]];
    }
    
    return self;
}

-(NSDictionary*)saveDataDictionary
{
    NSDictionary *saveDataDic = @{@"SaveSlot":[NSNumber numberWithInt:self.slotNumber],
                                  @"CurrencyPair":[self.currencyPair toArray],
                                  @"TimeScale":self.timeScale.minuteValueObj,
                                  @"StartTimestamp":self.startTime.timestampValueObj,
                                  @"Spread":self.spread.spreadValueObj,
                                  @"AccountCurrency":self.accountCurrency.toCodeString,
                                  @"StartBalance":self.startBalance.toMoneyValueObj,
                                  @"PositionSizeOfLot":[NSNumber numberWithUnsignedLongLong:self.positionSizeOfLot.sizeValue],
                                  //@"DefaultTradePositionSize":self.defaultTradePositionSize.sizeValueObj,
                                  @"TradePositionSize":self.tradePositionSize.sizeValueObj,
                                  @"LastLoadedCloseTimestamp":self.lastLoadedCloseTimestamp.timestampValueObj,
                                  @"IsAutoUpdate":[NSNumber numberWithBool:self.isAutoUpdate],
                                  @"AutoUpdateInterval":self.autoUpdateInterval,
                                  @"SubChartSelectedTimeScale":self.subChartSelectedTimeScale.minuteValueObj,
                                  @"OrderHistoryTableName":self.orderHistoryDataSource.tableName,
                                  @"ExecutionHistoryTableName":self.executionHistoryDataSource.tableName,
                                  @"OpenPositionTableName":self.openPositionDataSource.tableName};
    
    return saveDataDic;
}

@end
