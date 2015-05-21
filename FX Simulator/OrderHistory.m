//
//  OrderHistoryDatabase.m
//  ForexGame
//
//  Created  on 2014/06/23.
//  
//

#import "OrderHistory.h"

#import "TradeDbDataSource.h"
#import "TradeDatabase.h"
#import "SaveData.h"
#import "SaveLoader.h"
#import "FMDatabase.h"
#import "UsersOrder.h"
#import "ForexHistoryData.h"
#import "Rate.h"
#import "OrderType.h"
#import "PositionSize.h"

static NSString* const createOrderHistoryTableSql = @"create table if not exists [TABLE_NAME] (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, order_rate REAL NOT NULL, trade_type TXT NOT NULL, position_size INTEGER NOT NULL);";

@implementation OrderHistory {
    FMDatabase *tradeDatabase;
    NSNumber *_saveSlotNumber;
    NSString *tableName;
}

-(id)initWithDataSource:(TradeDbDataSource *)dataSource
{
    if (self = [super init]) {
        tradeDatabase = dataSource.connection;
        _saveSlotNumber = dataSource.saveSlotNumber;
        tableName = dataSource.tableName;
        //[self setTable];
    }
    
    return self;
}

/*-(void)setTable
{
    NSString *sql = [self replaceTableName:createOrderHistoryTableSql];
    
    [tradeDatabase open];
    
    [tradeDatabase executeUpdate:sql];
    
    [tradeDatabase close];
}*/

-(NSString*)replaceTableName:(NSString*)sql
{
    return [sql stringByReplacingOccurrencesOfString:@"[TABLE_NAME]" withString:tableName];
}

-(int)saveUsersOrder:(UsersOrder *)order
{
    NSString *sql = @"insert into [TABLE_NAME] (save_slot, order_rate, order_type, position_size) values (?, ?, ?, ?)";
    sql = [self replaceTableName:sql];
    
    //NSNumber *ratesID = [NSNumber numberWithInt:order.forexHistoryData.ratesID];
    NSNumber *orderRate = order.orderRate.rateValueObj;
    NSString *orderTypeString = order.orderType.toTypeString;
    NSNumber *positionSize = order.positionSize.sizeValueObj;
    
    [tradeDatabase open];
    
    int indexId = 0;
    
    if([tradeDatabase executeUpdate:sql, _saveSlotNumber, orderRate, orderTypeString, positionSize]) {
        indexId = [tradeDatabase lastInsertRowId];
    }
    
    [tradeDatabase close];
    
    return indexId;

}

@end
