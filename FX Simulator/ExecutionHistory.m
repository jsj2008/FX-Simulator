//
//  ExecutionHistory.m
//  FX Simulator
//
//  Created  on 2014/10/23.
//  
//

#import "ExecutionHistory.h"

#import "FMDatabase.h"
#import "TradeDatabase.h"
#import "ExecutionHistoryRecord.h"
#import "CloseExecutionOrder.h"
#import "NewExecutionOrder.h"
#import "ForexHistoryData.h"
#import "OrderType.h"

static NSString* const FXSExecutionHistoryTableName = @"execution_history";

@implementation ExecutionHistory {
    FMDatabase *_tradeDatabase;
    NSUInteger _saveSlotNumber;
}

+ (instancetype)createFromSlotNumber:(NSUInteger)slotNumber
{
    return [[self alloc] initWithSaveSlotNumber:slotNumber db:[TradeDatabase dbConnect]];
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
    
    FMResultSet *results = [_tradeDatabase executeQuery:sql, orderID, _saveSlotNumber];
    
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

@end
