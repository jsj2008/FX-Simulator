//
//  SQLiteOpenPositionModel.m
//  FX Simulator
//
//  Created  on 2014/09/09.
//  
//

#import "OpenPosition.h"

#import "TradeDatabase.h"
#import "FMDatabase.h"
#import "OpenPositionRecord.h"
#import "OpenPositionRawRecord.h"
#import "OpenPositionUtils.h"
#import "Lot.h"
#import "Rate.h"
#import "ProfitAndLossCalculator.h"
#import "Common.h"
#import "PositionSize.h"
#import "ExecutionHistoryFactory.h"
#import "ExecutionHistory.h"
#import "CurrencyConverter.h"
#import "Market.h"
#import "ForexHistoryData.h"
#import "NewExecutionOrder.h"
#import "CloseExecutionOrder.h"

static NSString* const FXSOpenPositionTableName = @"open_position";
static const int maxRecords = 3;

@implementation OpenPosition {
    ExecutionHistory *_executionHistory;
    FMDatabase *_tradeDatabase;
    NSUInteger _saveSlotNumber;
    NSArray *_allRecords;
}

+ (instancetype)createFromSlotNumber:(NSUInteger)slotNumber AccountCurrency:(Currency*)accountCurrency
{
    return [[self alloc] initWithSaveSlotNumber:slotNumber accountCurrency:accountCurrency db:[TradeDatabase dbConnect]];
}

-(id)init
{
    return nil;
}

- (instancetype)initWithSaveSlotNumber:(NSUInteger)slotNumber accountCurrency:(Currency*)accountCurrency db:(FMDatabase *)db
{
    if (self = [super init]) {
        _tradeDatabase = db;
        _saveSlotNumber = slotNumber;
        _currency = accountCurrency;
        
        _executionHistory = [ExecutionHistoryFactory createExecutionHistory];
        
        [self update];
    }
    
    return self;
}

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
    
    NSMutableArray *rawRecords = [NSMutableArray array];
    
    [_tradeDatabase open];
    
    FMResultSet *rs;
    
    rs = [_tradeDatabase executeQuery:sql, @(_saveSlotNumber)];
    
    while ([rs next]) {
        OpenPositionRawRecord *rawRecord = [[OpenPositionRawRecord alloc] initWithFMResultSet:rs];
        // ポジションサイズが０以上のものだけOpenPositionにする
        if (0 < rawRecord.positionSize.sizeValue) {
            [rawRecords addObject:rawRecord];
        }
    }
    
    [_tradeDatabase close];
    
    return [self convertToOpenPositionRecordsFromRawRecords:rawRecords];
}

/**
 @param rawRecords OpenPositionRawRecordの配列
*/

-(NSArray*)convertToOpenPositionRecordsFromRawRecords:(NSArray*)rawRecords
{
    // TODO: このメソッドだけ別クラスにする。 OpenPositionRecordConverter
    
    NSMutableArray *records = [NSMutableArray array];
    
    for (OpenPositionRawRecord *rawRecord in rawRecords) {
        ExecutionHistoryRecord *executionHistoryRecord = [_executionHistory selectRecordFromOrderID:rawRecord.executionOrderID];
        OpenPositionRecord *record = [[OpenPositionRecord alloc] initWithOpenPositionRawRecord:rawRecord executionHistoryRecord:executionHistoryRecord];
        [records addObject:record];
    }
    
    return [records copy];
}

-(Money*)profitAndLossForRate:(Rate*)rate
{
    Money *profitAndLoss = [ProfitAndLossCalculator calculateByTargetRate:self.averageRate valuationRate:rate positionSize:self.totalPositionSize orderType:self.orderType];
    
    return [CurrencyConverter convert:profitAndLoss to:self.currency];
}

-(Money*)marketValueForRate:(Rate*)rate
{
    return [rate multiplyPositionSize:self.totalPositionSize];
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

-(OrderType*)orderType
{
    OpenPositionRecord *record = [_allRecords firstObject];
    
    return record.orderType;
}

-(PositionSize*)totalPositionSize
{
    position_size_t positionSize = 0;
    
    for (OpenPositionRecord *record in _allRecords) {
        positionSize += record.positionSize.sizeValue;
    }
    
    return [[PositionSize alloc] initWithSizeValue:positionSize];
}

-(Lot*)totalLot
{
    return [self.totalPositionSize toLot];
}

-(Rate*)averageRate
{
    if (0 == self.totalPositionSize) {
        return [[Rate alloc] initWithRateValue:0 currencyPair:nil timestamp:nil];
    }
    
    //amount_t totalPosition = 0;
    rate_t averageRate = 0;
    
    for (OpenPositionRecord *record in _allRecords) {
        //totalPosition += record.orderRate.rateValue * record.positionSize.sizeValue;
        averageRate += record.orderRate.rateValue * record.positionSize.sizeValue / self.totalPositionSize.sizeValue;
    }
    
    //rate_t averageRate = totalPosition / self.totalPositionSize.sizeValue;
    
    CurrencyPair *currencyPair = ((OpenPositionRecord*)[_allRecords firstObject]).currencyPair;
    
    return [[Rate alloc] initWithRateValue:averageRate currencyPair:currencyPair timestamp:nil];
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
    
    for (id order in orders) {
        if ([order isKindOfClass:[CloseExecutionOrder class]]) {
            isSuccess = [self closeOpenPosition:order db:db];
        } else if ([order isKindOfClass:[NewExecutionOrder class]]) {
            isSuccess = [self newOpenPosition:order db:db];
        } else {
            return NO;
        }
        
        if (!isSuccess) {
            return NO;
        }
    }
    
    return YES;
}

-(BOOL)closeOpenPosition:(CloseExecutionOrder*)closeOrder db:(FMDatabase *)db
{
    if (closeOrder.isCloseAllPositionOfRecord) {
        return [self deleteOpenPositionNumber:closeOrder.closeOpenPositionNumber db:db];
    } else {
        return [self updateOpenPositionNumber:closeOrder.closeOpenPositionNumber closePositionSize:closeOrder.positionSize db:db];
    }
}

-(BOOL)newOpenPosition:(NewExecutionOrder*)newOrder db:(FMDatabase *)db
{
    return [self saveOpenPositionRecord:[[OpenPositionRecord alloc] initWithNewExecutionOrder:newOrder] db:db];
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
    
    NSString *sql = [NSString stringWithFormat:@"update %@ set position_size = position_size - ? where id = ? AND save_slot = ?", FXSOpenPositionTableName];
    
    if(![db executeUpdate:sql, positionSsize.sizeValue, @(number), @(_saveSlotNumber)]) {
        return false;
    }
    
    return true;
}

-(BOOL)saveOpenPositionRecord:(OpenPositionRecord*)record db:(FMDatabase *)db
{
    NSString *sql = [NSString stringWithFormat:@"insert into %@ (save_slot, execution_order_id, position_size) values (?, ?, ?);", FXSOpenPositionTableName];
    
    if([db executeUpdate:sql, @(_saveSlotNumber), @(record.executionOrderID), record.positionSize.sizeValueObj]) {
        return YES;
    } else {
        return NO;
    }
    
}

@end
