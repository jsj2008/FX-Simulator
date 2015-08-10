//
//  SaveData.m
//  FX Simulator
//
//  Created  on 2014/10/08.
//  
//

#import "SaveData.h"

#import "SaveDataSource.h"
#import "SaveDataSource+Additions.h"
#import "CoreDataManager.h"
#import "MarketTime.h"
#import "TimeFrame.h"
#import "Currency.h"
#import "CurrencyPair.h"
#import "FXSTimeRange.h"
#import "FXSTest.h"
#import "TableNameFormatter.h"
#import "Setting.h"
#import "Spread.h"
#import "PositionSize.h"
#import "Lot.h"
#import "Money.h"
#import "TradeTestDbDataSource.h"
#import "TradeDbDataSource.h"
#import "TimeScaleUtils.h"

@interface SaveData ()
@property (nonatomic) NSUInteger slotNumber;
@end

@implementation SaveData {
    SaveDataSource *_saveDataSource;
}

+ (instancetype)createSaveData
{
    SaveDataSource *source = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([SaveDataSource class]) inManagedObjectContext:[CoreDataManager sharedManager].managedObjectContext];
    
    SaveData *saveData = [[SaveData alloc] initWithSaveDataSource:source];
    
    return saveData;
}

+ (instancetype)createDefaultSaveDataFromSlotNumber:(NSUInteger)slotNumber
{
    SaveDataSource *source = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([SaveDataSource class]) inManagedObjectContext:[CoreDataManager sharedManager].managedObjectContext];
    
    [source setDefaultDataAndSlotNumber:slotNumber];
    [source setDefaultChartSources:[CoreDataManager sharedManager].managedObjectContext];
    
    SaveData *saveData = [[SaveData alloc] initWithSaveDataSource:source];

    return saveData;
}

- (instancetype)init
{
    return nil;
}

- (instancetype)initWithSaveDataSource:(SaveDataSource *)source
{
    if (self = [super init]) {
        _saveDataSource = source;
    }
    
    return self;
}

/*- (void)setDefaultDataAndSlotNumber:(NSUInteger)slotNumber
{
    self.slotNumber = (int)slotNumber;
    self.currencyPair = [[CurrencyPair alloc] initWithBaseCurrency:[[Currency alloc] initWithCurrencyType:USD] QuoteCurrency:[[Currency alloc] initWithCurrencyType:JPY]];
    self.timeFrame = [[TimeFrame alloc] initWithMinute:15];
    self.startTime = [Setting rangeForCurrencyPair:self.currencyPair timeScale:self.timeFrame].start;
    self.lastLoadedTime = self.startTime;
    self.spread = [[Spread alloc] initWithPips:1 currencyPair:self.currencyPair];
    self.accountCurrency = [[Currency alloc] initWithCurrencyType:JPY];
    self.startBalance = [[Money alloc] initWithAmount:1000000 currency:self.accountCurrency];
    self.positionSizeOfLot = [[PositionSize alloc] initWithSizeValue:10000];
    self.tradePositionSize = [[PositionSize alloc] initWithSizeValue:10000];
    self.isAutoUpdate = YES;
    self.autoUpdateInterval = 1.0;
}*/

- (void)delete
{
    [[CoreDataManager sharedManager].managedObjectContext deleteObject:_saveDataSource];
}

- (void)save
{
    [[CoreDataManager sharedManager] saveContext];
}

- (void)newSave
{
    [_saveDataSource setDefaultChartSources:[CoreDataManager sharedManager].managedObjectContext];
    [self save];
}

- (void)updateSave
{
    [self save];
}

#pragma mark - getter,setter

- (NSUInteger)slotNumber
{
    return _saveDataSource.fxsSlotNumber;
}

- (void)setCurrencyPair:(CurrencyPair *)currencyPair
{
    _saveDataSource.fxsCurrencyPair = currencyPair;
}

- (CurrencyPair *)currencyPair
{
    return _saveDataSource.fxsCurrencyPair;
}

- (void)setTimeFrame:(TimeFrame *)timeFrame
{
    _saveDataSource.fxsTimeFrame = timeFrame;
}

- (TimeFrame *)timeFrame
{
    return _saveDataSource.fxsTimeFrame;
}

- (void)setStartTime:(MarketTime *)startTime
{
    _saveDataSource.fxsStartTime = startTime;
}

- (MarketTime *)startTime
{
    return _saveDataSource.fxsStartTime;
}

- (void)setSpread:(Spread *)spread
{
    _saveDataSource.fxsSpread = spread;
}

- (Spread *)spread
{
    return _saveDataSource.fxsSpread;
}

- (void)setLastLoadedTime:(MarketTime *)lastLoadedTime
{
    _saveDataSource.fxsLastLoadedTime = lastLoadedTime;
}

- (MarketTime *)lastLoadedTime
{
    return _saveDataSource.fxsLastLoadedTime;
}

- (void)setAccountCurrency:(Currency *)accountCurrency
{
    _saveDataSource.fxsAccountCurrency = accountCurrency;
}

- (Currency *)accountCurrency
{
    return _saveDataSource.fxsAccountCurrency;
}

- (void)setPositionSizeOfLot:(PositionSize *)positionSizeOfLot
{
    _saveDataSource.fxsPositionSizeOfLot = positionSizeOfLot;
}

- (PositionSize *)positionSizeOfLot
{
    return _saveDataSource.fxsPositionSizeOfLot;
}

- (void)setTradePositionSize:(PositionSize *)tradePositionSize
{
    _saveDataSource.fxsTradePositionSize = tradePositionSize;
}

- (PositionSize *)tradePositionSize
{
    return _saveDataSource.fxsTradePositionSize;
}

- (void)setStartBalance:(Money *)startBalance
{
    _saveDataSource.fxsStartBalance = startBalance;
}

- (Money *)startBalance
{
    return _saveDataSource.fxsStartBalance;
}

- (void)setIsAutoUpdate:(BOOL)isAutoUpdate
{
    _saveDataSource.fxsIsAutoUpdate = isAutoUpdate;
}

- (BOOL)isAutoUpdate
{
    return _saveDataSource.fxsIsAutoUpdate;
}

- (void)setAutoUpdateInterval:(float)autoUpdateInterval
{
    _saveDataSource.fxsAutoUpdateIntervalSeconds = autoUpdateInterval;
}

- (float)autoUpdateInterval
{
    return _saveDataSource.fxsAutoUpdateIntervalSeconds;
}

/*-(id)initWithSaveDataDictionary:(NSDictionary*)dic
{
    if (dic == nil) {
        return nil;
    }
    
    if (self = [super init]) {
        Currency *baseCurrency = [[Currency alloc] initWithString:[[dic objectForKey:@"CurrencyPair"] objectAtIndex:0]];
        Currency *quoteCurrency = [[Currency alloc] initWithString:[[dic objectForKey:@"CurrencyPair"] objectAtIndex:1]];
        
        _slotNumber = [[dic objectForKey:@"SaveSlot"] intValue];
        _currencyPair = [[CurrencyPair alloc] initWithBaseCurrency:baseCurrency QuoteCurrency:quoteCurrency];
        _timeFrame = [[TimeFrame alloc] initWithMinute:[[dic objectForKey:@"TimeScale"] intValue]];
        _startTime = [[MarketTime alloc] initWithTimestamp:[[dic objectForKey:@"StartTimestamp"] intValue]];
        _spread = [[Spread alloc] initWithPips:[[dic objectForKey:@"Spread"] doubleValue] currencyPair:_currencyPair];
        _accountCurrency = [[Currency alloc] initWithString:[dic objectForKey:@"AccountCurrency"]];
        _startBalance = [[Money alloc] initWithAmount:[[dic objectForKey:@"StartBalance"] longLongValue] currency:_accountCurrency];
        _positionSizeOfLot = [[PositionSize alloc] initWithSizeValue:[[dic objectForKey:@"PositionSizeOfLot"] unsignedLongLongValue]];
        //_defaultTradePositionSize = [[PositionSize alloc] initWithSizeValue:[[dic objectForKey:@"DefaultTradePositionSize"] unsignedLongLongValue]];
        _tradePositionSize = [[PositionSize alloc] initWithSizeValue:[[dic objectForKey:@"TradePositionSize"] unsignedLongLongValue]];
        //_lot = [[Lot alloc] initWithLotValue:[[dic objectForKey:@"Lot"] unsignedLongLongValue]];
        _lastLoadedTime = [[MarketTime alloc] initWithTimestamp:[[dic objectForKey:@"LastLoadedCloseTimestamp"] intValue]];
        _isAutoUpdate = [[dic objectForKey:@"IsAutoUpdate"] boolValue];
        _autoUpdateInterval = [NSNumber numberWithFloat:[[dic objectForKey:@"AutoUpdateInterval"] floatValue]];
        _subChartSelectedTimeScale = [[TimeFrame alloc] initWithMinute:[[dic objectForKey:@"SubChartSelectedTimeScale"] intValue]];
        
        if (![FXSTest inTest]) {
            _orderHistoryDataSource = [[TradeDbDataSource alloc] initWithTableName:[dic objectForKey:@"OrderHistoryTableName"] SaveSlotNumber:[NSNumber numberWithInt:_slotNumber]];
            _executionHistoryDataSource = [[TradeDbDataSource alloc] initWithTableName:[dic objectForKey:@"ExecutionHistoryTableName"] SaveSlotNumber:[NSNumber numberWithInt:_slotNumber]];
            _openPositionDataSource = [[TradeDbDataSource alloc] initWithTableName:[dic objectForKey:@"OpenPositionTableName"] SaveSlotNumber:[NSNumber numberWithInt:_slotNumber]];
        } else {
            _orderHistoryDataSource = [[TradeTestDbDataSource alloc] initWithTableName:[dic objectForKey:@"OrderHistoryTableName"] SaveSlotNumber:[NSNumber numberWithInt:_slotNumber]];
            _executionHistoryDataSource = [[TradeTestDbDataSource alloc] initWithTableName:[dic objectForKey:@"ExecutionHistoryTableName"] SaveSlotNumber:[NSNumber numberWithInt:_slotNumber]];
            _openPositionDataSource = [[TradeTestDbDataSource alloc] initWithTableName:[dic objectForKey:@"OpenPositionTableName"] SaveSlotNumber:[NSNumber numberWithInt:_slotNumber]];
        }
    }
    
    return self;
}*/

/*-(id)initWithDefaultDataAndSlotNumber:(int)slotNumber
{
    if (self = [super init]) {
        _tradePositionSize = [[PositionSize alloc] initWithSizeValue:10000];
        _isAutoUpdate = YES;
        _autoUpdateInterval = @1.0;
        _subChartSelectedTimeScale = [[TimeFrame alloc] initWithMinute:60];
        
        _slotNumber = slotNumber;
        _currencyPair = [[CurrencyPair alloc] initWithBaseCurrency:[[Currency alloc] initWithCurrencyType:USD] QuoteCurrency:[[Currency alloc] initWithCurrencyType:JPY]];
        _timeFrame = [[TimeFrame alloc] initWithMinute:15];
        _startTime = [Setting rangeForCurrencyPair:_currencyPair timeScale:_timeFrame].start;
        _lastLoadedTime = _startTime;
        _spread = [[Spread alloc] initWithPips:1 currencyPair:_currencyPair];
        _accountCurrency = [[Currency alloc] initWithCurrencyType:JPY];
        _startBalance = [[Money alloc] initWithAmount:1000000 currency:_accountCurrency];
        _positionSizeOfLot = [[PositionSize alloc] initWithSizeValue:10000];
        
        
        NSString *orderHistoryTableName = @"order_history";
        NSString *executionHistoryTableName = @"execution_history";
        NSString *openPositionTableName = @"open_position";
        
        if (![FXSTest inTest]) {
            _orderHistoryDataSource = [[TradeDbDataSource alloc] initWithTableName:orderHistoryTableName SaveSlotNumber:[NSNumber numberWithInt:slotNumber]];
            _executionHistoryDataSource = [[TradeDbDataSource alloc] initWithTableName:executionHistoryTableName SaveSlotNumber:[NSNumber numberWithInt:slotNumber]];
            _openPositionDataSource = [[TradeDbDataSource alloc] initWithTableName:openPositionTableName SaveSlotNumber:[NSNumber numberWithInt:slotNumber]];
        } else {
            _orderHistoryDataSource = [[TradeTestDbDataSource alloc] initWithTableName:orderHistoryTableName SaveSlotNumber:[NSNumber numberWithInt:slotNumber]];
            _executionHistoryDataSource = [[TradeTestDbDataSource alloc] initWithTableName:executionHistoryTableName SaveSlotNumber:[NSNumber numberWithInt:slotNumber]];
            _openPositionDataSource = [[TradeTestDbDataSource alloc] initWithTableName:openPositionTableName SaveSlotNumber:[NSNumber numberWithInt:slotNumber]];
        }
        
        
        
        
 
    }
    
    return self;
}

-(NSDictionary*)saveDataDictionary
{
    NSDictionary *saveDataDic = @{@"SaveSlot":[NSNumber numberWithInt:self.slotNumber],
                                  @"CurrencyPair":[self.currencyPair toArray],
                                  @"TimeScale":self.timeFrame.minuteValueObj,
                                  @"StartTimestamp":self.startTime.timestampValueObj,
                                  @"Spread":self.spread.spreadValueObj,
                                  @"AccountCurrency":self.accountCurrency.toCodeString,
                                  @"StartBalance":self.startBalance.toMoneyValueObj,
                                  @"PositionSizeOfLot":[NSNumber numberWithUnsignedLongLong:self.positionSizeOfLot.sizeValue],
                                  //@"DefaultTradePositionSize":self.defaultTradePositionSize.sizeValueObj,
                                  @"TradePositionSize":self.tradePositionSize.sizeValueObj,
                                  @"LastLoadedCloseTimestamp":self.lastLoadedTime.timestampValueObj,
                                  @"IsAutoUpdate":[NSNumber numberWithBool:self.isAutoUpdate],
                                  @"AutoUpdateInterval":self.autoUpdateInterval,
                                  @"SubChartSelectedTimeScale":self.subChartSelectedTimeScale.minuteValueObj,
                                  @"OrderHistoryTableName":self.orderHistoryDataSource.tableName,
                                  @"ExecutionHistoryTableName":self.executionHistoryDataSource.tableName,
                                  @"OpenPositionTableName":self.openPositionDataSource.tableName};
    
    return saveDataDic;
}

- (void)setTimeFrame:(TimeFrame *)timeScale
{
    _timeFrame = timeScale;
    _subChartSelectedTimeScale = [TimeScaleUtils selectTimeScaleListExecept:self.timeFrame fromTimeScaleList:[Setting timeScaleList]].firstObject;
}*/

@end
