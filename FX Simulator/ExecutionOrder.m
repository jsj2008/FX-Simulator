//
//  ExecutionOrder.m
//  FX Simulator
//
//  Created  on 2014/11/23.
//  
//

#import "ExecutionOrder.h"

#import "TradeDatabase+Protected.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "CurrencyPair.h"
#import "Money.h"
#import "OpenPosition.h"
#import "Order.h"
#import "PositionSize.h"
#import "PositionType.h"
#import "ProfitAndLossCalculator.h"
#import "Rate.h"
#import "Spread.h"
#import "Time.h"

static NSString* const FXSExecutionOrdersTableName = @"execution_orders";

@interface ExecutionOrder ()

@property (nonatomic) NSUInteger recordId;
@property (nonatomic) NSUInteger orderId;
@property (nonatomic) BOOL isClose;
@property (nonatomic) NSUInteger closeTargetExecutionOrderId;
@property (nonatomic) NSUInteger closeTargetOrderId;
@property (nonatomic) BOOL isExecuteOrder;
@property (nonatomic) OpenPosition *executeCloseTargetOpenPosition;
@end

@implementation ExecutionOrder

+ (instancetype)createNewExecutionOrderFromOrder:(Order *)order
{
    ExecutionOrder *executionOrder = [[[self class] alloc] initWithCurrencyPair:order.currencyPair positionType:order.positionType rate:order.rate positionSize:order.positionSize];
    executionOrder.recordId = 0;
    executionOrder.orderId = order.orderId;
    executionOrder.isClose = NO;
    
    executionOrder.isExecuteOrder = YES;
    executionOrder.executeCloseTargetOpenPosition = nil;
    
    return executionOrder;
}

+ (instancetype)createCloseExecutionOrderFromCloseTargetOpenPosition:(OpenPosition *)openPosition order:(Order *)order
{
    if ([openPosition isNewPosition]) {
        return nil;
    }
    
    ExecutionOrder *executionOrder = [[[self class] alloc] initWithCurrencyPair:order.currencyPair positionType:order.positionType rate:order.rate positionSize:openPosition.positionSize];
    executionOrder.recordId = 0;
    executionOrder.orderId = order.orderId;
    executionOrder.isClose = YES;
    executionOrder.closeTargetExecutionOrderId = openPosition.executionOrderId;
    executionOrder.closeTargetOrderId = openPosition.orderId;
    
    executionOrder.isExecuteOrder = YES;
    executionOrder.executeCloseTargetOpenPosition = openPosition;
    
    return executionOrder;
}

+ (NSArray *)allClosedOrdersOfCurrencyPair:(CurrencyPair *)currencyPair
{
    NSMutableArray *allOrders = [NSMutableArray array];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE save_slot = ? AND code = ? AND is_close = ?", FXSExecutionOrdersTableName];
    
    [self execute:^(FMDatabase *db, NSUInteger saveSlot) {
        
        FMResultSet *result = [db executeQuery:sql, @(saveSlot), currencyPair.toCodeString, @(YES)];
        
        while ([result next]) {
            ExecutionOrder *order = [[ExecutionOrder alloc] initWithFMResultSet:result];
            [allOrders addObject:order];
        }
    }];
    
    return [allOrders copy];
}

+ (ExecutionOrder *)orderAtId:(NSUInteger)recordId
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE save_slot = ? AND id = ?", FXSExecutionOrdersTableName];
    
    __block ExecutionOrder *order;
    
    [self execute:^(FMDatabase *db, NSUInteger saveSlot) {
        
        FMResultSet *result = [db executeQuery:sql, @(saveSlot), @(recordId)];
        
        while ([result next]) {
            order = [[ExecutionOrder alloc] initWithFMResultSet:result];
        }
        
        [result close];
        
    }];
    
    return order;
}

+ (Money *)profitAndLossOfCurrencyPair:(CurrencyPair *)currencyPair
{
    NSArray *allOrders = [self allClosedOrdersOfCurrencyPair:currencyPair];
    
    Money *profitAndLoss = [[Money alloc] initWithAmount:0 currency:currencyPair.quoteCurrency];
    
    for (ExecutionOrder *order in allOrders) {
        profitAndLoss = [profitAndLoss addMoney:[order profitAndLoss]];
    }
    
    return profitAndLoss;
}

+ (NSArray *)selectNewestFirstLimit:(NSUInteger)limit
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE save_slot = ? ORDER BY id DESC Limit ?", FXSExecutionOrdersTableName];
    
    NSMutableArray *array = [NSMutableArray array];
    
    [self execute:^(FMDatabase *db, NSUInteger saveSlot) {

        FMResultSet *result = [db executeQuery:sql, @(saveSlot), @(limit)];
        
        while ([result next]) {
            ExecutionOrder *order = [[ExecutionOrder alloc] initWithFMResultSet:result];
            [array addObject:order];
        }
        
    }];
    
    return array;
}

- (instancetype)initWithFMResultSet:(FMResultSet *)result
{
    CurrencyPair *currencyPair = [[CurrencyPair alloc] initWithCurrencyPairString:[result stringForColumn:@"code"]];
    Time *rateTime = [[Time alloc] initWithTimestamp:[result intForColumn:@"timestamp"]];
    Rate *rate = [[Rate alloc] initWithRateValue:[result doubleForColumn:@"rate"] currencyPair:currencyPair timestamp:rateTime];
    PositionType *positionType = [PositionType new];
    
    if ([result boolForColumn:@"is_long"]) {
        [positionType setLong];
    } else if ([result boolForColumn:@"is_short"]) {
        [positionType setShort];
    }
    
    PositionSize *positionSize = [[PositionSize alloc] initWithSizeValue:[result intForColumn:@"position_size"]];
    
    if (self = [super initWithCurrencyPair:currencyPair positionType:positionType rate:rate positionSize:positionSize]) {
        _recordId = [result intForColumn:@"id"];
        _orderId = [result intForColumn:@"order_id"];
        _isClose = [result boolForColumn:@"is_close"];
        _closeTargetExecutionOrderId = [result intForColumn:@"close_target_execution_order_id"];
        _closeTargetOrderId = [result intForColumn:@"close_target_order_id"];
        self.isExecuteOrder = NO;
    }
    
    return self;
}

- (void)execute
{
    if (self.isClose) {
        [self.executeCloseTargetOpenPosition close];
        [self save];
    } else {
        [self save];
        OpenPosition *newOpenPosition = [OpenPosition createNewOpenPositionFromExecutionOrder:self executionOrderId:self.recordId];
        [newOpenPosition new];
    }    
}

- (void)save
{
    if (![self validate]) {
        [NSException raise:@"ExecutionOrderException" format:@"Validate Error"];
    }
    
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ ( save_slot, order_id, code, is_short, is_long, rate, timestamp, position_size, is_close, close_target_execution_order_id, close_target_order_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);", FXSExecutionOrdersTableName];
    
    [[self  class] execute:^(FMDatabase *db, NSUInteger saveSlot) {

        if([db executeUpdate:sql, @(saveSlot), @(self.orderId), self.currencyPair.toCodeString, @(self.positionType.isShort), @(self.positionType.isLong), self.rate.rateValueObj, self.rate.timestamp.timestampValueObj, self.positionSize.sizeValueObj, @(self.isClose), @(self.closeTargetExecutionOrderId), @(self.closeTargetOrderId)]) {
            
            NSString *sql = [NSString stringWithFormat:@"select MAX(id) as MAX_ID from %@ WHERE save_slot = ?;", FXSExecutionOrdersTableName];
            
            FMResultSet *result = [db executeQuery:sql, @(saveSlot)];
            
            while ([result next]) {
                self.recordId = [result intForColumn:@"MAX_ID"];
            }
            
            if (self.recordId == 0) {
                [NSException raise:@"ExecutionOrderException" format:@"DB Error: 0 records"];
            }

        } else {
            self.recordId = 0;
            [NSException raise:@"ExecutionOrderException" format:@"DB Error: execute failed"];
        }
        
    }];
}

- (BOOL)validate
{
    if (!self.isExecuteOrder || ![self.positionSize existsPosition]) {
        return NO;
    }
    
    if (self.isClose) {
        if (self.closeTargetExecutionOrderId == 0 || self.closeTargetOrderId == 0) {
            return NO;
        }
    }
    
    return YES;
}

- (Money *)profitAndLoss
{
    if (!self.isClose || self.isExecuteOrder) {
        return nil;
    }
    
    ExecutionOrder *closeTargetOrder = [[self class] orderAtId:self.closeTargetExecutionOrderId];
    
    if (!closeTargetOrder) {
        return nil;
    }
    
    return [ProfitAndLossCalculator calculateByTargetRate:self.rate valuationRate:closeTargetOrder.rate positionSize:self.positionSize orderType:self.positionType];
}

@end
