//
//  SQLiteOpenPositionModel.m
//  FX Simulator
//
//  Created  on 2014/09/09.
//  
//

#import "OpenPosition.h"

#import "SaveData.h"
#import "SaveLoader.h"
#import "TradeDatabase.h"
#import "FMDatabase.h"
#import "OpenPositionRecord.h"
#import "OpenPositionRawRecord.h"
#import "OpenPositionUtils.h"
#import "OrderType.h"
#import "Lot.h"
#import "Rate.h"
#import "Rates.h"
#import "ProfitAndLossCalculator.h"
#import "Common.h"
#import "PositionSize.h"
#import "ExecutionHistory.h"
#import "ExecutionOrder.h"
#import "CurrencyConverter.h"
#import "Market.h"
#import "Money.h"
#import "ForexHistoryData.h"
#import "CurrencyPair.h"

static NSString* const FXSOpenPositionTableName = @"open_position";
static const int maxRecords = 50;

@implementation OpenPosition {
    OrderHistory *_orderHistory;
    //ExecutionHistory *_executionHistory;
    FMDatabase *_tradeDatabase;
    NSUInteger _saveSlotNumber;
    NSArray *_allRecords;
}

+ (instancetype)createFromSlotNumber:(NSUInteger)slotNumber
{
    SaveData *saveData = [SaveLoader load];
    
    return [[self alloc] initWithSaveSlotNumber:slotNumber orderHistory:saveData.orderHistory db:[TradeDatabase dbConnect]];
}

/*+ (instancetype)createFromSlotNumber:(NSUInteger)slotNumber
{
    SaveData *saveData = [SaveLoader load];
    
    return [[self alloc] initWithSaveSlotNumber:slotNumber executionHistory:saveData.executionHistory db:[TradeDatabase dbConnect]];
}*/

+ (instancetype)loadOpenPosition
{
    SaveData *saveData = [SaveLoader load];
    
    return saveData.openPosition;
}

-(id)init
{
    return nil;
}

- (instancetype)initWithSaveSlotNumber:(NSUInteger)slotNumber orderHistory:(OrderHistory *)orderHistory db:(FMDatabase *)db
{
    if (self = [super init]) {
        _tradeDatabase = db;
        _saveSlotNumber = slotNumber;
        _orderHistory = orderHistory;
        
        [self update];
    }
    
    return self;
}

/*- (instancetype)initWithSaveSlotNumber:(NSUInteger)slotNumber executionHistory:(ExecutionHistory *)executionHistory db:(FMDatabase *)db
{
    if (self = [super init]) {
        _tradeDatabase = db;
        _saveSlotNumber = slotNumber;
        _executionHistory = executionHistory;
        
        [self update];
    }
    
    return self;
}*/

-(void)update
{
    _allRecords = [self selectAll];
}

#warning Limit(OpenPositionViewController);
-(NSArray*)selectLatestDataLimit:(NSNumber *)num
{
    NSArray *all = [self selectAll];
    
    //return [[[all reverseObjectEnumerator] allObjects] subarrayWithRange:NSMakeRange(0,  num.unsignedIntegerValue)];
    return [[all reverseObjectEnumerator] allObjects];
}

-(NSArray*)selectLimitPositionSize:(PositionSize*)positionSize
{
    NSArray *all = [self selectAll];
    
    return [OpenPositionUtils selectLimitPositionSize:positionSize fromOpenPositionRecords:all];
}

-(NSArray*)selectAll
{
    NSString *sql = [NSString stringWithFormat:@"select * from %@ WHERE save_slot = ?", FXSOpenPositionTableName];
    
    NSMutableArray *records = [NSMutableArray array];
    
    [_tradeDatabase open];
    
    FMResultSet *rs;
    
    rs = [_tradeDatabase executeQuery:sql, @(_saveSlotNumber)];
    
    while ([rs next]) {
        OpenPositionRecord *record = [[OpenPositionRecord alloc] initWithFMResultSet:rs orderHistory:_orderHistory];
        // ポジションサイズが０以上のものだけOpenPositionにする
        if (0 < record.positionSize.sizeValue) {
            [records addObject:record];
        }
    }
    
    [_tradeDatabase close];
    
    return records;
}

/**
 @param rawRecords OpenPositionRawRecordの配列
*/

/*-(NSArray*)convertToOpenPositionRecordsFromRawRecords:(NSArray*)rawRecords
{
    // TODO: このメソッドだけ別クラスにする。 OpenPositionRecordConverter
    
    NSMutableArray *records = [NSMutableArray array];
    
    for (OpenPositionRawRecord *rawRecord in rawRecords) {
        ExecutionHistoryRecord *executionHistoryRecord = [_executionHistory selectRecordFromOrderID:rawRecord.executionHistoryId];
        OpenPositionRecord *record = [[OpenPositionRecord alloc] initWithOpenPositionRawRecord:rawRecord executionHistoryRecord:executionHistoryRecord];
        [records addObject:record];
    }
    
    return [records copy];
}*/

- (NSArray *)allOpenPositionRecordsOfCurrencyPair:(CurrencyPair *)currencyPair
{
    NSArray *allOpenPositionRecords = [self selectAll];
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (OpenPositionRecord *record in allOpenPositionRecords) {
        if ([record.currencyPair isEqualCurrencyPair:currencyPair]) {
            [array addObject:record];
        }
    }
    
    return [array copy];
}

- (OrderType *)orderTypeOfCurrencyPair:(CurrencyPair *)currencyPair
{
    OpenPositionRecord *record = [self allOpenPositionRecordsOfCurrencyPair:currencyPair].firstObject;
    
    return record.orderType;
}

- (Money *)profitAndLossForMarket:(Market *)market currencyPair:(CurrencyPair *)currencyPair InCurrency:(Currency *)currency
{
    OrderType *orderType = [self orderTypeOfCurrencyPair:currencyPair];
    
    Rates *valuationRates = [market getCurrentRatesOfCurrencyPair:currencyPair];
    
    Rate *valuationRate;
    
    if ([orderType isShort]) {
        valuationRate = valuationRates.askRate;
    } else if ([orderType isLong]) {
        valuationRate = valuationRates.bidRate;
    } else {
        return [[Money alloc] initWithAmount:0 currency:currency];
    }
    
    PositionSize *totalPositionSize = [self totalPositionSizeOfCurrencyPair:currencyPair];
    Rate *averageRate = [self averageRateOfCurrencyPair:currencyPair];
    
    Money *profitAndLoss = [ProfitAndLossCalculator calculateByTargetRate:averageRate valuationRate:valuationRate positionSize:totalPositionSize orderType:orderType];
    
    return [profitAndLoss convertToCurrency:currency];
}

- (PositionSize *)totalPositionSizeOfCurrencyPair:(CurrencyPair *)currencyPair
{
    NSArray *allRecords = [self allOpenPositionRecordsOfCurrencyPair:currencyPair];
    
    position_size_t positionSize = 0;
    
    for (OpenPositionRecord *record in allRecords) {
        positionSize += record.positionSize.sizeValue;
    }
    
    return [[PositionSize alloc] initWithSizeValue:positionSize];
}

- (Lot *)totalLotOfCurrencyPair:(CurrencyPair *)currencyPair
{
    return [[self totalPositionSizeOfCurrencyPair:currencyPair] toLot];
}

- (Rate *)averageRateOfCurrencyPair:(CurrencyPair *)currencyPair
{
    NSArray *allRecords = [self allOpenPositionRecordsOfCurrencyPair:currencyPair];
    PositionSize *totalPositionSize = [self totalPositionSizeOfCurrencyPair:currencyPair];
    
    rate_t averageRate = 0;
    
    for (OpenPositionRecord *record in allRecords) {
        averageRate += record.orderRate.rateValue * record.positionSize.sizeValue / totalPositionSize.sizeValue;
    }
    
    return [[Rate alloc] initWithRateValue:averageRate currencyPair:currencyPair timestamp:nil];
}

-(BOOL)isMax
{
    if (maxRecords < [self countAllRecords]) {
        return YES;
    } else {
        return NO;
    }
}

/**
 レコード数をカウント
*/
-(int)countAllRecords
{
    NSString *sql = [NSString stringWithFormat:@"select count(*) as count from %@;", FXSOpenPositionTableName];
    
    [_tradeDatabase open];
    
    FMResultSet *rs = [_tradeDatabase executeQuery:sql];
    
    int count = 0;
    
    while ([rs next]) {
        count  = [rs intForColumn:@"count"];
    }
    
    [_tradeDatabase close];
    
    return count;
}

- (void)delete
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE save_slot = ?;", FXSOpenPositionTableName];
    
    [_tradeDatabase open];
    [_tradeDatabase executeUpdate:sql, @(_saveSlotNumber)];
    [_tradeDatabase close];
}

/*-(Money*)totalPositionMarketValue
{
    
}*/

#pragma mark - execute orders

-(BOOL)execute:(NSArray *)orders db:(FMDatabase *)db
{
    if (!self.inExecutionOrdersTransaction) {
        return NO;
    }
    
    BOOL isSuccess;
    
    for (ExecutionOrder *order in orders) {
        if (order.isClose) {
            isSuccess = [self closeOpenPosition:order db:db];
        } else {
            isSuccess = [self newOpenPosition:order db:db];
        }
        /*if ([order isKindOfClass:[CloseExecutionOrder class]]) {
            isSuccess = [self closeOpenPosition:order db:db];
        } else if ([order isKindOfClass:[NewExecutionOrder class]]) {
            isSuccess = [self newOpenPosition:order db:db];
        } else {
            return NO;
        }*/
        
        if (!isSuccess) {
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)closeOpenPosition:(ExecutionOrder *)closeOrder db:(FMDatabase *)db
{
    return [self updateOpenPositionNumber:closeOrder.closeTargetOpenPositionId closePositionSize:closeOrder.positionSize db:db];
    
    /*if (closeOrder.isCloseAllPositionOfRecord) {
        return [self deleteOpenPositionNumber:closeOrder.closeOpenPositionNumber db:db];
    } else {
        return [self updateOpenPositionNumber:closeOrder.closeOpenPositionNumber closePositionSize:closeOrder.positionSize db:db];
    }*/
}

- (BOOL)newOpenPosition:(ExecutionOrder *)newOrder db:(FMDatabase *)db
{
    return [self saveOpenPositionRawRecordFromNewExecutionOrder:newOrder db:db];
}

-(BOOL)deleteOpenPositionNumber:(int)num db:(FMDatabase *)db
{
    NSString *sql = [NSString stringWithFormat:@"delete from %@ where id = ? AND save_slot = ?", FXSOpenPositionTableName];
    
    if(![db executeUpdate:sql, @(num), @(_saveSlotNumber)]) {
        return false;
    }
    
    return true;
}

-(BOOL)updateOpenPositionNumber:(int)number closePositionSize:(PositionSize*)positionSsize db:(FMDatabase *)db
{
    // PositionSizeが0のRecordはそのままにしておく　OpenPositionでRecordを取得するときは0以上のものだけ取得
    
    NSString *sql = [NSString stringWithFormat:@"update %@ set open_position_size = open_position_size - ? where id = ? AND save_slot = ?", FXSOpenPositionTableName];
    
    if(![db executeUpdate:sql, positionSsize.sizeValueObj, @(number), @(_saveSlotNumber)]) {
        return false;
    }
    
    return true;
}

-(BOOL)saveOpenPositionRawRecordFromNewExecutionOrder:(ExecutionOrder *)order db:(FMDatabase *)db
{
    NSString *sql = [NSString stringWithFormat:@"insert into %@ (save_slot, order_history_id, execution_history_id, open_position_size) values (?, ?, ?, ?);", FXSOpenPositionTableName];
    
    if([db executeUpdate:sql, @(_saveSlotNumber), @(order.orderHistoryId), @(order.executionHistoryId), order.positionSize.sizeValueObj]) {
        return YES;
    } else {
        return NO;
    }
    
}

@end
