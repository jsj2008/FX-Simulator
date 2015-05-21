//
//  ExecutionHistoryManager.m
//  FX Simulator
//
//  Created  on 2014/11/25.
//  
//

#import "ExecutionHistoryManager.h"

#import "TradeDbDataSource.h"
#import "FMDatabase.h"
#import "TradeDatabase.h"
#import "CloseExecutionOrder.h"
#import "NewExecutionOrder.h"
#import "CurrencyPair.h"
#import "ForexHistoryData.h"
#import "Rate.h"
#import "MarketTime.h"
#import "OrderType.h"
#import "Spread.h"
#import "PositionSize.h"

typedef struct{
    int rowID;
    BOOL isSuccess;
} SaveOrderResult;

@implementation ExecutionHistoryManager {
    NSString *_tableName;
    NSNumber *_saveSlotNumber;
}

-(id)initWithDataSource:(TradeDbDataSource *)dataSource
{
    if (self = [super init]) {
        //ExecutionHistoryTable *table = [[ExecutionHistoryTable alloc] initWithDataSource:dataSource];
        //[table setTable];
        _tableName = dataSource.tableName;
        _saveSlotNumber = dataSource.saveSlotNumber;
    }
    
    return self;
}

-(NSString*)replaceTableName:(NSString*)sql
{
    return [sql stringByReplacingOccurrencesOfString:@"[TABLE_NAME]" withString:_tableName];
}

-(NSArray*)saveOrders:(NSArray *)orders
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
        result = [self saveOrder:order];
        if (result.isSuccess) {
            order.orderID = result.rowID;
        } else {
            return nil;
        }
    }
    
    return orders;
}

-(SaveOrderResult)saveOrder:(id)order
{
    NSString *sql = @"insert into [TABLE_NAME] (save_slot, currency_pair, users_order_number, order_rate, order_rate_timestamp, order_spread, order_type, position_size, is_close, close_order_number, close_order_rate, close_order_spread) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);";
    sql = [self replaceTableName:sql];
    
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
    
    if(![self.tradeDB executeUpdate:sql, _saveSlotNumber, currencyPair, usersOrderNumber, orderRate, orderRateTimestamp, orderSpread, orderType, positionSize, isClose, closeUsersOrderNumber, closeOrderRate, closeOrderSpread]) {
        NSLog(@"db error: ExecutionHistoryManager saveExecutionOrders");
        result.isSuccess = NO;
    } else {
        result.rowID = [self.tradeDB lastInsertRowId];
        result.isSuccess = YES;
    }
    
    return result;
}

/*-(BOOL)execute:(NSArray *)orders
{
    if (!self.inExecutionOrdersTransaction) {
        return NO;
    }
    
    return [self saveExecutionOrders:orders];
}*/

/*-(BOOL)saveExecutionOrders:(NSArray *)orders
{
    NSString *sql = @"insert into [TABLE_NAME] (currency_pair, users_order_number, currency_data_id, order_rate, order_spread, trade_type, position_size, is_close, close_order_number, close_order_rate, close_order_spread) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);";
    sql = [self replaceTableName:sql];
    
    //[tradeDatabase open];
    
    //[tradeDatabase beginTransaction];
    
    //BOOL isSucceeded = YES;
    
    NSString *currencyPair;
    NSNumber *usersOrderNumber;
    NSNumber *ratesID;
    NSNumber *orderRate;
    NSNumber *orderSpread;
    NSString *orderType;
    NSNumber *positionSize;
    NSNumber *isClose;
    NSNumber *closeUsersOrderNumber;
    NSNumber *closeOrderRate;
    NSNumber *closeOrderSpread;
    
    for (id order in orders) {
        if ([order isKindOfClass:[CloseExecutionOrder class]]) {
            CloseExecutionOrder *_order = order;
            currencyPair = _order.currencyPair.toDbCode;
            usersOrderNumber = [NSNumber numberWithInt:_order.usersOrderNumber];
            ratesID = [NSNumber numberWithInt:_order.forexHistoryData.ratesID];
            orderRate = _order.forexHistoryData.close.rateValueObj;
            orderSpread = _order.orderSpread.spreadValueObj;
            orderType = _order.orderType.toTypeString;
            positionSize = _order.positionSize.sizeValueObj;
            isClose = [NSNumber numberWithBool:YES];
            closeUsersOrderNumber = [NSNumber numberWithInt:_order.closeUsersOrderNumber];
            closeOrderRate = _order.closeOrderRate.rateValueObj;
            closeOrderSpread = _order.closeOrderSpread.spreadValueObj;
        } else if ([order isKindOfClass:[NewExecutionOrder class]]) {
            NewExecutionOrder *_order = order;
            currencyPair = _order.currencyPair.toDbCode;
            usersOrderNumber = [NSNumber numberWithInt:_order.usersOrderNumber];
            ratesID = [NSNumber numberWithInt:_order.forexHistoryData.ratesID];
            orderRate = _order.forexHistoryData.close.rateValueObj;
            orderSpread = _order.orderSpread.spreadValueObj;
            orderType = _order.orderType.toTypeString;
            positionSize = _order.positionSize.sizeValueObj;
            isClose = [NSNumber numberWithBool:NO];
            closeUsersOrderNumber = nil;
            closeOrderRate = nil;
            closeOrderSpread = nil;
        } else {
            //isSucceeded = NO;
            //break;
            return  NO;
        }
        
        int rowID = 0;
        
        if(![self.tradeDB executeUpdate:sql, currencyPair, usersOrderNumber, ratesID, orderRate, orderSpread, orderType, positionSize, isClose, closeUsersOrderNumber, closeOrderRate, closeOrderSpread]) {
            NSLog(@"db error: ExecutionHistoryManager saveExecutionOrders");
            //isSucceeded = NO;
            //break;
            return NO;
        } else {
            rowID = [self.tradeDB lastInsertRowId];
        }
        
    }
    
    return YES;
    
}*/

@end
