//
//  ExecutionHistory.m
//  FX Simulator
//
//  Created  on 2014/10/23.
//  
//

#import "ExecutionHistory.h"

#import "SaveData.h"
#import "SaveLoader.h"
#import "FMDatabase.h"
#import "TradeDatabase.h"
#import "ExecutionHistoryRecord.h"
#import "CloseExecutionOrder.h"
#import "NewExecutionOrder.h"
#import "ForexHistoryData.h"
#import "OrderType.h"
#import "CloseExecutionOrder.h"
#import "NewExecutionOrder.h"
#import "CurrencyPair.h"
#import "Rate.h"
#import "MarketTime.h"
#import "Spread.h"
#import "PositionSize.h"

static NSString* const FXSExecutionHistoryTableName = @"execution_history";

@implementation ExecutionHistory {
    FMDatabase *_tradeDatabase;
    NSUInteger _saveSlotNumber;
}

+ (instancetype)createFromSlotNumber:(NSUInteger)slotNumber
{
    return [[self alloc] initWithSaveSlotNumber:slotNumber db:[TradeDatabase dbConnect]];
}

+ (instancetype)loadExecutionHistory
{
    SaveData *saveData = [SaveLoader load];
    
    return saveData.executionHistory;
}

- (instancetype)initWithSaveSlotNumber:(NSUInteger)slotNumber db:(FMDatabase *)db
{
    if (self = [super init]) {
        _saveSlotNumber = slotNumber;
        _tradeDatabase = db;
    }
    
    return self;
}

-(ExecutionHistoryRecord*)selectRecordFromOrderID:(NSNumber *)orderID
{
    NSString *sql = [NSString stringWithFormat:@"SELECT rowid,* FROM %@ WHERE is_close = 0 AND rowid = ? AND save_slot = ?", FXSExecutionHistoryTableName];
    
    ExecutionHistoryRecord *record;
    
    [_tradeDatabase open];
    
    FMResultSet *results = [_tradeDatabase executeQuery:sql, orderID, @(_saveSlotNumber)];
    
    while ([results next]) {
        record = [[ExecutionHistoryRecord alloc] initWithFMResultSet:results];
        //[array addObject:record];
    }
    
    [_tradeDatabase close];
    
    return record;
}

-(NSArray*)selectLatestDataLimit:(NSNumber *)num
{
    NSString *sql = [NSString stringWithFormat:@"SELECT rowid,* FROM %@ WHERE save_slot = ? ORDER BY rowid DESC Limit ?", FXSExecutionHistoryTableName];
    
    NSMutableArray *array = [NSMutableArray array];
    
    [_tradeDatabase open];
    
    FMResultSet *results = [_tradeDatabase executeQuery:sql, @(_saveSlotNumber), num];
    
    while ([results next]) {
        ExecutionHistoryRecord *record = [[ExecutionHistoryRecord alloc] initWithFMResultSet:results];
        [array addObject:record];
    }
    
    [_tradeDatabase close];
    
    return [array copy];
}

-(NSArray*)all
{
    NSString *sql = [NSString stringWithFormat:@"SELECT rowid,* FROM %@ WHERE save_slot = ?", FXSExecutionHistoryTableName];
    
    NSMutableArray *array = [NSMutableArray array];
    
    [_tradeDatabase open];
    
    FMResultSet *results = [_tradeDatabase executeQuery:sql, @(_saveSlotNumber)];
    
    while ([results next]) {
        ExecutionHistoryRecord *record = [[ExecutionHistoryRecord alloc] initWithFMResultSet:results];
        [array addObject:record];
    }
    
    [_tradeDatabase close];
    
    return [array copy];
}

- (void)delete
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE save_slot = ?;", FXSExecutionHistoryTableName];
    
    [_tradeDatabase open];
    [_tradeDatabase executeUpdate:sql, @(_saveSlotNumber)];
    [_tradeDatabase close];
}

#pragma mark - execute orders

typedef struct{
    int rowID;
    BOOL isSuccess;
} SaveOrderResult;

-(NSArray*)saveOrders:(NSArray *)orders db:(FMDatabase *)db
{
    if (!self.inExecutionOrdersTransaction) {
        return nil;
    }
    
    for (id order in orders) {
        if (![order isKindOfClass:[ExecutionOrder class]]) {
            return nil;
        }
    }
    
    for (ExecutionOrder *order in orders) {
        SaveOrderResult result;
        result = [self saveOrder:order db:db];
        if (result.isSuccess) {
            order.orderID = result.rowID;
        } else {
            return nil;
        }
    }
    
    return orders;
}

-(SaveOrderResult)saveOrder:(id)order db:(FMDatabase *)db
{
    NSString *sql = [NSString stringWithFormat:@"insert into %@ (save_slot, currency_pair, users_order_number, order_rate, order_rate_timestamp, order_spread, order_type, position_size, is_close, close_order_number, close_order_rate, close_order_spread) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);", FXSExecutionHistoryTableName];
    
    NSString *currencyPair;
    NSNumber *usersOrderNumber;
    //NSNumber *ratesID;
    NSNumber *orderRate;
    NSNumber *orderRateTimestamp;
    NSNumber *orderSpread;
    NSString *orderType;
    NSNumber *positionSize;
    NSNumber *isClose;
    NSNumber *closeUsersOrderNumber;
    NSNumber *closeOrderRate;
    NSNumber *closeOrderSpread;
    
    SaveOrderResult result;
    result.rowID = 0;
    
    if ([order isMemberOfClass:[CloseExecutionOrder class]]) {
        CloseExecutionOrder *_order = order;
        currencyPair = _order.currencyPair.toCodeString;
        usersOrderNumber = [NSNumber numberWithInt:_order.usersOrderNumber];
        orderRate = _order.orderRate.rateValueObj;
        orderRateTimestamp = _order.orderRate.timestamp.timestampValueObj;
        /*ratesID = [NSNumber numberWithInt:_order.forexHistoryData.ratesID];
         orderRate = _order.forexHistoryData.close.rateValueObj;
         orderRateTimestamp = _order.forexHistoryData.close.timestamp.timestampValueObj;*/
        orderSpread = _order.orderSpread.spreadValueObj;
        orderType = _order.orderType.toTypeString;
        positionSize = _order.positionSize.sizeValueObj;
        isClose = [NSNumber numberWithBool:YES];
        closeUsersOrderNumber = [NSNumber numberWithInt:_order.closeUsersOrderNumber];
        closeOrderRate = _order.closeOrderRate.rateValueObj;
        closeOrderSpread = _order.closeOrderSpread.spreadValueObj;
    } else if ([order isMemberOfClass:[NewExecutionOrder class]]) {
        NewExecutionOrder *_order = order;
        currencyPair = _order.currencyPair.toCodeString;
        usersOrderNumber = [NSNumber numberWithInt:_order.usersOrderNumber];
        //ratesID = [NSNumber numberWithInt:_order.forexHistoryData.ratesID];
        orderRate = _order.orderRate.rateValueObj;
        orderRateTimestamp = _order.orderRate.timestamp.timestampValueObj;
        orderSpread = _order.orderSpread.spreadValueObj;
        orderType = _order.orderType.toTypeString;
        positionSize = _order.positionSize.sizeValueObj;
        isClose = [NSNumber numberWithBool:NO];
        closeUsersOrderNumber = nil;
        closeOrderRate = nil;
        closeOrderSpread = nil;
    } else {
        result.isSuccess = NO;
    }
    
    if(![db executeUpdate:sql, @(_saveSlotNumber), currencyPair, usersOrderNumber, orderRate, orderRateTimestamp, orderSpread, orderType, positionSize, isClose, closeUsersOrderNumber, closeOrderRate, closeOrderSpread]) {
        NSLog(@"db error: ExecutionHistoryManager saveExecutionOrders");
        result.isSuccess = NO;
    } else {
        result.rowID = [db lastInsertRowId];
        result.isSuccess = YES;
    }
    
    return result;
}

@end
