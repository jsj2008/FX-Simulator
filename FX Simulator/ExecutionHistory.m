//
//  ExecutionHistory.m
//  FX Simulator
//
//  Created  on 2014/10/23.
//  
//

#import "ExecutionHistory.h"

#import "TradeDbDataSource.h"
//#import "ExecutionHistoryTable.h"
//#import "SaveData.h"
//#import "SaveLoader.h"
#import "FMDatabase.h"
//#import "TradeDatabase.h"
#import "ExecutionHistoryRecord.h"
#import "CloseExecutionOrder.h"
#import "NewExecutionOrder.h"
#import "ForexHistoryData.h"
#import "OrderType.h"

//static NSString* const createExecutionHistoryTableSql = @"create table if not exists [TABLE_NAME] (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, users_order_number INTEGER NOT NULL, currency_data_id INTEGER NOT NULL, order_rate REAL NOT NULL, trade_type TXT NOT NULL, lot INTEGER NOT NULL, is_close BOOL NOT NULL, close_order_number INTEGER, close_order_rate REAL);";

@implementation ExecutionHistory {
    FMDatabase *tradeDatabase;
    NSNumber *_saveSlotNumber;
    NSString *_tableName;
}

-(id)initWithDataSource:(TradeDbDataSource*)dataSource
{
    if (self = [super init]) {
        //ExecutionHistoryTable *table = [[ExecutionHistoryTable alloc] initWithDataSource:dataSource];
        //[table setTable];
        tradeDatabase = dataSource.connection;
        _saveSlotNumber = dataSource.saveSlotNumber;
        _tableName = dataSource.tableName;
        //[self loadSaveData];
        //[self setTable];
    }
    
    return self;
}

/*-(void)loadSaveData
{
    SaveData *saveData = [SaveLoader load];
    tableName = saveData.executionHistoryTableName;
}

-(void)setTable
{
    NSString *sql = [self replaceTableName:createExecutionHistoryTableSql];
    
    [tradeDatabase open];
    
    [tradeDatabase executeUpdate:sql];
    
    [tradeDatabase close];
}*/

-(NSString*)replaceTableName:(NSString*)sql
{
    return [sql stringByReplacingOccurrencesOfString:@"[TABLE_NAME]" withString:_tableName];
}

-(ExecutionHistoryRecord*)selectRecordFromOrderID:(NSNumber *)orderID
{
    // TODO: rowidだけでよくないか。
    //NSString *sql = [NSString stringWithFormat:@"SELECT rowid,* FROM %@ WHERE is_close = 0 AND rowid = %d AND save_slot = %d", _tableName, [orderID intValue], _saveSlotNumber.intValue];
    NSString *sql = @"SELECT rowid,* FROM [TABLE_NAME] WHERE is_close = 0 AND rowid = ? AND save_slot = ?";
    sql = [self replaceTableName:sql];
    //NSMutableArray *array = [NSMutableArray array];
    
    ExecutionHistoryRecord *record;
    
    [tradeDatabase open];
    
    FMResultSet *results = [tradeDatabase executeQuery:sql, orderID, _saveSlotNumber];
    
    while ([results next]) {
        record = [[ExecutionHistoryRecord alloc] initWithFMResultSet:results];
        //[array addObject:record];
    }
    
    [tradeDatabase close];
    
    return record;
}

-(NSArray*)selectLatestDataLimit:(NSNumber *)num
{
    //NSString *sql = [NSString stringWithFormat:@"SELECT rowid,* FROM %@ WHERE save_slot = %d ORDER BY rowid DESC Limit %d", _tableName, _saveSlotNumber, num.unsignedIntValue];
    //NSString *sql = @"SELECT rowid,* FROM ? WHERE save_slot = ? ORDER BY rowid DESC Limit ?";
    
    NSString *sql = [NSString stringWithFormat:@"SELECT rowid,* FROM %@ WHERE save_slot = ? ORDER BY rowid DESC Limit ?",_tableName];
    
    NSMutableArray *array = [NSMutableArray array];
    
    [tradeDatabase open];
    
    FMResultSet *results = [tradeDatabase executeQuery:sql, _saveSlotNumber, num];
    
    while ([results next]) {
        ExecutionHistoryRecord *record = [[ExecutionHistoryRecord alloc] initWithFMResultSet:results];
        [array addObject:record];
    }
    
    [tradeDatabase close];
    
    return [array copy];
}

-(NSArray*)all
{
    NSString *sql = [NSString stringWithFormat:@"SELECT rowid,* FROM %@ WHERE save_slot = ?", _tableName];
    
    NSMutableArray *array = [NSMutableArray array];
    
    [tradeDatabase open];
    
    FMResultSet *results = [tradeDatabase executeQuery:sql, _saveSlotNumber];
    
    while ([results next]) {
        ExecutionHistoryRecord *record = [[ExecutionHistoryRecord alloc] initWithFMResultSet:results];
        [array addObject:record];
    }
    
    [tradeDatabase close];
    
    return [array copy];
}

/*-(BOOL)saveExecutionOrders:(NSArray *)orders
{
    NSString *sql = @"insert into [TABLE_NAME] (users_order_number, currency_data_id, order_rate, trade_type, lot, is_close, close_order_number, close_order_rate) values (?, ?, ?, ?, ?, ?, ?, ?);";
    sql = [self replaceTableName:sql];
    
    [tradeDatabase open];
    
    [tradeDatabase beginTransaction];
    
    BOOL isSucceeded = YES;
    
    NSNumber *usersOrderNumber;
    NSNumber *ratesID;
    NSNumber *orderRate;
    NSString *orderType;
    NSNumber *positionSize;
    NSNumber *isClose;
    NSNumber *closeUsersOrderNumber;
    NSNumber *closeOrderRate;
    
    for (id order in orders) {
        if ([order isKindOfClass:[CloseExecutionOrder class]]) {
            CloseExecutionOrder *_order = order;
            usersOrderNumber = [NSNumber numberWithInt:_order.usersOrderNumber];
            ratesID = [NSNumber numberWithInt:_order.forexHistoryData.ratesID];
            orderRate = [NSNumber numberWithDouble:_order.forexHistoryData.close];
            orderType = _order.orderType.toString;
            positionSize = [NSNumber numberWithUnsignedLongLong:_order.positionSize];
            isClose = [NSNumber numberWithBool:YES];
            closeUsersOrderNumber = [NSNumber numberWithInt:_order.closeUsersOrderNumber];
            closeOrderRate = [NSNumber numberWithDouble:_order.closeOrderRate];
        } else if ([order isKindOfClass:[NewExecutionOrder class]]) {
            NewExecutionOrder *_order = order;
            usersOrderNumber = [NSNumber numberWithInt:_order.usersOrderNumber];
            ratesID = [NSNumber numberWithInt:_order.forexHistoryData.ratesID];
            orderRate = [NSNumber numberWithDouble:_order.forexHistoryData.close];
            orderType = _order.orderType.toString;
            positionSize = [NSNumber numberWithUnsignedLongLong:_order.positionSize];
            isClose = [NSNumber numberWithBool:NO];
            closeUsersOrderNumber = nil;
            closeOrderRate = nil;
        } else {
            isSucceeded = NO;
            break;
        }
        
        if(![tradeDatabase executeUpdate:sql, usersOrderNumber, ratesID, orderRate, orderType, positionSize, isClose, closeUsersOrderNumber, closeOrderRate]) {
            isSucceeded = NO;
            break;
        }
        
    }
    
    if(isSucceeded) {
        [tradeDatabase commit];
    } else {
        [tradeDatabase rollback];
    }
    
    [tradeDatabase close];
    
    if (isSucceeded) {
        return YES;
    } else {
        return NO;
    }
}*/

/*-(BOOL)saveClosePositionOrder:(id<ClosePositionOrderProtocol>)order
{
    NSString *sql = @"insert into [TABLE_NAME] (users_order_number, currency_data_id, order_rate, trade_type, lot, is_close, close_order_number, close_order_rate) values (?, ?, ?, ?, ?, ?, ?, ?);";
    sql = [self replaceTableName:sql];
    
    NSNumber *usersOrderNumber = [NSNumber numberWithInt:order.usersOrderNumber];
    NSNumber *ratesID = [NSNumber numberWithInt:order.ratesID];
    NSNumber *orderRate = [NSNumber numberWithDouble:order.orderRate];
    NSString *orderType = order.orderType;
    NSNumber *lot = [NSNumber numberWithUnsignedLongLong:order.lot];
    NSNumber *isClose = [NSNumber numberWithBool:true];
    NSNumber *closeOrderNumber = [NSNumber numberWithInt:order.closeOrderNumber];
    NSNumber *closeOrderRate = [NSNumber numberWithDouble:order.closeOrderRate];
    
    [tradeDatabase open];
    
    if(![tradeDatabase executeUpdate:sql, usersOrderNumber, ratesID, orderRate, orderType, lot, isClose, closeOrderNumber, closeOrderRate]) {
        [tradeDatabase close];
        
        return false;
    }
    
    [tradeDatabase close];
    
    return true;

}

-(BOOL)saveNewPositionOrder:(id<NewPositionOrderProtocol>)order
{
    NSString *sql = @"insert into [TABLE_NAME] (users_order_number, currency_data_id, order_rate, trade_type, lot, is_close) values (?, ?, ?, ?, ?, ?);";
    sql = [self replaceTableName:sql];
    
    NSNumber *usersOrderNumber = [NSNumber numberWithInt:order.usersOrderNumber];
    NSNumber *ratesID = [NSNumber numberWithInt:order.ratesID];
    NSNumber *orderRate = [NSNumber numberWithDouble:order.orderRate];
    NSString *orderType = order.orderType;
    NSNumber *lot = [NSNumber numberWithUnsignedLongLong:order.lot];
    NSNumber *isClose = [NSNumber numberWithBool:false];
    
    [tradeDatabase open];
    
    if(![tradeDatabase executeUpdate:sql, usersOrderNumber, ratesID, orderRate, orderType, lot, isClose]) {
        [tradeDatabase close];
        
        return false;
    }
    
    [tradeDatabase close];
    
    return true;
}*/

/*-(NSArray*)all
{
    NSMutableArray *array = [NSMutableArray array];
    
    NSString *sql = @"select * from [TABLE_NAME];";
    sql = [self replaceTableName:sql];
    
    [tradeDatabase open];
    
    FMResultSet *rs;
    
    rs = [tradeDatabase executeQuery:sql];
    
    while ([rs next]) {
        BOOL isClose = [rs boolForColumn:@"is_close"];
        if (isClose) {
            id<ClosePositionOrderProtocol> order = [ClosePositionOrderFactory createClosePositionOrderFromFMResultSet:rs];
            [array addObject:order];
        } else {
            id<NewPositionOrderProtocol> order = [NewPositionOrderFactory createNewPositionOrderFromFMResultSet:rs];
            [array addObject:order];
        }
    }
    
    [tradeDatabase close];
    
    
    return [[array reverseObjectEnumerator] allObjects];
}*/

/*-(NSMutableArray*)select:(NSRange)range
{
    NSMutableArray *array = [NSMutableArray array];
    
    return array;
}*/

@end
