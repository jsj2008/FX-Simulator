//
//  OrderHistoryDatabase.m
//  ForexGame
//
//  Created  on 2014/06/23.
//  
//

#import "OrderHistory.h"

#import "CurrencyPair.h"
#import "TradeDatabase.h"
#import "SaveData.h"
#import "SaveLoader.h"
#import "Spread.h"
#import "FMDatabase.h"
#import "UsersOrder.h"
#import "ForexHistoryData.h"
#import "MarketTime.h"
#import "Rate.h"
#import "PositionType.h"
#import "PositionSize.h"

static NSString* const FXSOrderHistoryTableName = @"order_history";

@implementation OrderHistory {
    FMDatabase *_tradeDatabase;
    NSUInteger _saveSlotNumber;
}

+ (instancetype)createFromSlotNumber:(NSUInteger)slotNumber
{
    return [[self alloc] initWithSaveSlotNumber:slotNumber db:[TradeDatabase dbConnect]];
}

+ (instancetype)loadOrderHistory
{
    SaveData *saveData = [SaveLoader load];
    
    return saveData.orderHistory;
}

-(instancetype)initWithSaveSlotNumber:(NSUInteger)slotNumber db:(FMDatabase *)db
{
    if (self = [super init]) {
        _tradeDatabase = db;
        _saveSlotNumber = slotNumber;
    }
    
    return self;
}

- (Order *)getOrderFromOrderHistoryId:(NSUInteger)orderHistoryId
{
    NSString *sql = [NSString stringWithFormat:@"select * from %@ WHERE id = ?", FXSOrderHistoryTableName];
    
    [_tradeDatabase open];
    
    FMResultSet *rs;
    
    rs = [_tradeDatabase executeQuery:sql, @(orderHistoryId)];
    
    Order *order;
    
    while ([rs next]) {
        order = [[Order alloc] initWithFMResultSet:rs];
    }
    
    [_tradeDatabase close];

    return order;
}

- (int)saveOrder:(Order *)order
{
    NSString *sql = [NSString stringWithFormat:@"insert into %@ ( save_slot, code, order_type, order_bid_rate, order_timestamp, position_size, order_spread) values (?, ?, ?, ?, ?, ?, ?)", FXSOrderHistoryTableName];
    //NSString *sql = [NSString stringWithFormat:@"insert into %@ (save_slot, order_rate, order_type, position_size) values (?, ?, ?, ?)", FXSOrderHistoryTableName];
    
    NSString *code = [order.currencyPair toCodeString];
    NSString *orderTypeString = order.orderType.toTypeString;
    NSNumber *orderRate = order.orderRate.rateValueObj;
    NSNumber *orderTimestamp = order.orderRate.timestamp.timestampValueObj;
    NSNumber *positionSize = order.positionSize.sizeValueObj;
    NSNumber *orderSpread = order.orderSpread.spreadValueObj;
    
    [_tradeDatabase open];
    
    int indexId = 0;
    
    if([_tradeDatabase executeUpdate:sql, @(_saveSlotNumber), code, orderTypeString, orderRate, orderTimestamp, positionSize, orderSpread]) {
        
        NSString *sql = [NSString stringWithFormat:@"select MAX(id) as MAX_ID from %@;", FXSOrderHistoryTableName];
        
        FMResultSet *resultSet = [_tradeDatabase executeQuery:sql];
        
        while ([resultSet next]) {
            indexId = [resultSet intForColumn:@"MAX_ID"];
        }

        //indexId = [_tradeDatabase lastInsertRowId];
    }
    
    [_tradeDatabase close];
    
    return indexId;
}

- (void)delete
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE save_slot = ?;", FXSOrderHistoryTableName];
    
    [_tradeDatabase open];
    [_tradeDatabase executeUpdate:sql, @(_saveSlotNumber)];
    [_tradeDatabase close];
}

@end
