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

static NSString* const FXSOrderHistoryTableName = @"order_history";

@implementation OrderHistory {
    FMDatabase *_tradeDatabase;
    NSUInteger _saveSlotNumber;
}

+ (instancetype)createFromSlotNumber:(NSUInteger)slotNumber
{
    return [[self alloc] initWithSaveSlotNumber:slotNumber db:[TradeDatabase dbConnect]];
}

-(instancetype)initWithSaveSlotNumber:(NSUInteger)slotNumber db:(FMDatabase *)db
{
    if (self = [super init]) {
        _tradeDatabase = db;
        _saveSlotNumber = slotNumber;
    }
    
    return self;
}

-(int)saveUsersOrder:(UsersOrder *)order
{
    NSString *sql = [NSString stringWithFormat:@"insert into %@ (save_slot, order_rate, order_type, position_size) values (?, ?, ?, ?)", FXSOrderHistoryTableName];
    
    NSNumber *orderRate = order.orderRate.rateValueObj;
    NSString *orderTypeString = order.orderType.toTypeString;
    NSNumber *positionSize = order.positionSize.sizeValueObj;
    
    [_tradeDatabase open];
    
    int indexId = 0;
    
    if([_tradeDatabase executeUpdate:sql, @(_saveSlotNumber), orderRate, orderTypeString, positionSize]) {
        indexId = [_tradeDatabase lastInsertRowId];
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
