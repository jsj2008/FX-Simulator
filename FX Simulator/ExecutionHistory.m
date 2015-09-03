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
#import "ExecutionOrder.h"
#import "ForexHistoryData.h"
#import "OrderHistory.h"
#import "PositionType.h"
#import "CurrencyPair.h"
#import "Rate.h"
#import "MarketTime.h"
#import "Spread.h"
#import "PositionSize.h"

static NSString* const FXSExecutionHistoryTableName = @"execution_history";

@implementation ExecutionHistory {
    FMDatabase *_tradeDatabase;
    OrderHistory *_orderHistory;
    NSUInteger _saveSlotNumber;
}

+ (instancetype)createFromSlotNumber:(NSUInteger)slotNumber
{
    return [[self alloc] initWithSaveSlotNumber:slotNumber orderHistory:[SaveLoader load].orderHistory db:[TradeDatabase dbConnect]];
}

+ (instancetype)loadExecutionHistory
{
    SaveData *saveData = [SaveLoader load];
    
    return saveData.executionHistory;
}

- (instancetype)initWithSaveSlotNumber:(NSUInteger)slotNumber orderHistory:(OrderHistory *)orderHistory db:(FMDatabase *)db
{
    if (self = [super init]) {
        _saveSlotNumber = slotNumber;
        _orderHistory = orderHistory;
        _tradeDatabase = db;
    }
    
    return self;
}

- (ExecutionOrder *)selectRecordFromOrderID:(NSUInteger)orderID
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE is_close = 0 AND order_history_id = ? AND save_slot = ?", FXSExecutionHistoryTableName];
    
    ExecutionOrder *order;
    
    [_tradeDatabase open];
    
    FMResultSet *result = [_tradeDatabase executeQuery:sql, @(orderID), @(_saveSlotNumber)];
    
    while ([result next]) {
        order = [[ExecutionOrder alloc] initWithFMResultSet:result orderHistory:_orderHistory];
    }
    
    [_tradeDatabase close];
    
    return order;
}

- (ExecutionOrder *)orderAtExecutionHistoryId:(NSUInteger)recordId
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE save_slot = ? AND id = ?", FXSExecutionHistoryTableName];
    
    ExecutionOrder *order;
    
    [_tradeDatabase open];
    
    FMResultSet *result = [_tradeDatabase executeQuery:sql, @(_saveSlotNumber), @(recordId)];
    
    while ([result next]) {
        order = [[ExecutionOrder alloc] initWithFMResultSet:result orderHistory:_orderHistory];
    }
    
    [_tradeDatabase close];
    
    return order;
}

- (NSArray *)selectLatestDataLimit:(NSNumber *)num
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE save_slot = ? ORDER BY id DESC Limit ?", FXSExecutionHistoryTableName];
    
    NSMutableArray *array = [NSMutableArray array];
    
    [_tradeDatabase open];
    
    FMResultSet *result = [_tradeDatabase executeQuery:sql, @(_saveSlotNumber), num];
    
    while ([result next]) {
        ExecutionOrder *order = [[ExecutionOrder alloc] initWithFMResultSet:result orderHistory:_orderHistory];
        [array addObject:order];
    }
    
    [_tradeDatabase close];
    
    return [array copy];
}

- (NSArray *)all
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE save_slot = ?", FXSExecutionHistoryTableName];
    
    NSMutableArray *array = [NSMutableArray array];
    
    [_tradeDatabase open];
    
    FMResultSet *result = [_tradeDatabase executeQuery:sql, @(_saveSlotNumber)];
    
    while ([result next]) {
        ExecutionOrder *order = [[ExecutionOrder alloc] initWithFMResultSet:result orderHistory:_orderHistory];
        [array addObject:order];
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
    int executionHistoryId;
    BOOL isSuccess;
} SaveOrderResult;

- (NSArray *)saveOrders:(NSArray *)orders db:(FMDatabase *)db
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
            order.executionHistoryId = result.executionHistoryId;
        } else {
            return nil;
        }
    }
    
    return orders;
}

-(SaveOrderResult)saveOrder:(ExecutionOrder *)order db:(FMDatabase *)db
{
    NSString *sql = [NSString stringWithFormat:@"insert into %@ (save_slot, order_history_id, execution_position_size, is_close, close_target_execution_history_id, close_target_order_history_id) values (?, ?, ?, ?, ?, ?);", FXSExecutionHistoryTableName];
    
    NSNumber *saveSlot = @(_saveSlotNumber);
    NSNumber *orderHistoryId = @(order.orderHistoryId);
    NSNumber *executionPositionSize = order.positionSize.sizeValueObj;
    NSNumber *isClose = @(order.isClose);
    NSNumber *closeTargetExecutionHistoryId = @(order.closeTargetExecutionHistoryId);
    NSNumber *closeTargetOrderHistoryId = @(order.closeTargetOrderHistoryId);
    
    SaveOrderResult result;
    result.executionHistoryId = 0;
    
    if(![db executeUpdate:sql, saveSlot, orderHistoryId, executionPositionSize, isClose, closeTargetExecutionHistoryId, closeTargetOrderHistoryId]) {
        NSLog(@"db error: ExecutionHistoryManager saveExecutionOrders");
        result.isSuccess = NO;
    } else {
        
        NSString *sql = [NSString stringWithFormat:@"select MAX(id) as MAX_ID from %@;", FXSExecutionHistoryTableName];
        
        NSUInteger currentExecutionHistoryId = 0;
        
        FMResultSet *resultSet = [db executeQuery:sql];
        
        while ([resultSet next]) {
            currentExecutionHistoryId = [resultSet intForColumn:@"MAX_ID"];
        }
        
        result.executionHistoryId = currentExecutionHistoryId;
        result.isSuccess = YES;
    }
    
    return result;
}

@end
