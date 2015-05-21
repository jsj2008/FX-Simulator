//
//  OpenPositionManager.m
//  FX Simulator
//
//  Created  on 2014/11/25.
//  
//

#import "OpenPositionManager.h"

#import "TradeDbDataSource.h"
#import "OpenPositionRecord.h"
#import "TradeDatabase.h"
#import "FMDatabase.h"
#import "CloseExecutionOrder.h"
#import "NewExecutionOrder.h"
#import "ForexHistoryData.h"
#import "Rate.h"
#import "Spread.h"
#import "OrderType.h"
#import "PositionSize.h"

@implementation OpenPositionManager {
    NSString *_tableName;
    NSNumber *_saveSlotNumber;
}

/*-(id)init
{
    if (self = [super init]) {
        OpenPositionTable *table = [OpenPositionTable new];
        [table setTable];
        _tableName = table.tableName;
    }
    
    return self;
}*/

-(id)initWithDataSource:(TradeDbDataSource*)dataSource
{
    if (self = [super init]) {
        //OpenPositionTable *table = [[OpenPositionTable alloc] initWithDataSource:dataSource];
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

-(BOOL)execute:(NSArray *)orders
{
    if (!self.inExecutionOrdersTransaction) {
        return NO;
    }
    
    BOOL isSuccess;
    
    for (id order in orders) {
        if ([order isKindOfClass:[CloseExecutionOrder class]]) {
            isSuccess = [self closeOpenPosition:order];
        } else if ([order isKindOfClass:[NewExecutionOrder class]]) {
            isSuccess = [self newOpenPosition:order];
        } else {
            return NO;
        }
        
        if (!isSuccess) {
            return NO;
        }
    }
    
    return YES;
}

-(BOOL)closeOpenPosition:(CloseExecutionOrder*)closeOrder
{
    if (closeOrder.isCloseAllPositionOfRecord) {
        return [self deleteOpenPositionNumber:closeOrder.closeOpenPositionNumber];
    } else {
        return [self updateOpenPositionNumber:closeOrder.closeOpenPositionNumber closePositionSize:closeOrder.positionSize];
    }
}

-(BOOL)newOpenPosition:(NewExecutionOrder*)newOrder
{
    return [self saveOpenPositionRecord:[[OpenPositionRecord alloc] initWithNewExecutionOrder:newOrder]];
}

-(BOOL)deleteOpenPositionNumber:(int)num
{
    NSString *sql = @"delete from [TABLE_NAME] where id = ? AND save_slot = ?";
    
    sql = [self replaceTableName:sql];
    
    //sql = [NSString stringWithFormat:@"%@%d", sql, num];
    
    //[self.tradeDB open];
    
    if(![self.tradeDB executeUpdate:sql, [NSNumber numberWithInt:num], _saveSlotNumber]) {
        //[tradeDatabase close];
        
        return false;
    }
    
    //[tradeDatabase close];
    
    return true;
}

-(BOOL)updateOpenPositionNumber:(int)number closePositionSize:(PositionSize*)positionSsize
{
    //NSString *sql1 = @"update [TABLE_NAME] set position_size = position_size - ";
    //NSString *sql2 = @" where id = ";
    //NSString *sql = [NSString stringWithFormat:@"%@%llu%@%d", sql1, positionSsize.sizeValue, sql2, number];
    
    // PositionSizeが0のRecordはそのままにしておく　OpenPositionでRecordを取得するときは0以上のものだけ取得
    NSString *sql = @"update [TABLE_NAME] set position_size = position_size - ? where id = ? AND save_slot = ?";
    
    sql = [self replaceTableName:sql];
    
    //[tradeDatabase open];
    
    if(![self.tradeDB executeUpdate:sql, positionSsize.sizeValue, number, _saveSlotNumber]) {
        
        return false;
        
        //[tradeDatabase close];
    }
    
    //[tradeDatabase close];
    
    return true;
}

-(BOOL)saveOpenPositionRecord:(OpenPositionRecord*)record
{
    NSString *sql = @"insert into [TABLE_NAME] (save_slot, execution_order_id, position_size) values (?, ?, ?);";
    sql = [self replaceTableName:sql];
    
    //NSNumber *orderNumber = [NSNumber numberWithInt:record.orderNumber];
    /*NSNumber *ratesID = [NSNumber numberWithInt:record.ratesId];
    NSNumber *orderRate = record.orderRate.rateValueObj;
    NSNumber *orderSpread = record.orderSpread.spreadValueObj;
    NSString *_orderTypeString = record.orderType.toString;
    NSNumber *_positionSize = record.positionSize.sizeValueObj;*/
    
    if([self.tradeDB executeUpdate:sql, _saveSlotNumber,[NSNumber numberWithInt:record.executionOrderID], record.positionSize.sizeValueObj]) {
        return YES;
    } else {
        return NO;
    }
    
}

/*-(BOOL)saveOpenPositionRecord:(OpenPositionRecord*)record
{
    NSString *sql = @"insert into [TABLE_NAME] (users_order_number, currency_data_id, order_rate, order_spread, trade_type, position_size) values (?, ?, ?, ?, ?, ?);";
    sql = [self replaceTableName:sql];
    
    NSNumber *orderNumber = [NSNumber numberWithInt:record.orderNumber];
    NSNumber *ratesID = [NSNumber numberWithInt:record.ratesId];
    NSNumber *orderRate = record.orderRate.rateValueObj;
    NSNumber *orderSpread = record.orderSpread.spreadValueObj;
    NSString *_orderTypeString = record.orderType.toString;
    NSNumber *_positionSize = record.positionSize.sizeValueObj;
    
    if(![self.tradeDB executeUpdate:sql, orderNumber, ratesID, orderRate, orderSpread, _orderTypeString, _positionSize]) {
        
        return false;
    }
    
    return true;
}*/


@end
