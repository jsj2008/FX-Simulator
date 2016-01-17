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
#import "ExecutionOrderComponents.h"
#import "Lot.h"
#import "Money.h"
#import "OpenPosition.h"
#import "OpenPositionComponents.h"
#import "Order.h"
#import "PositionSize.h"
#import "PositionType.h"
#import "ProfitAndLossCalculator.h"
#import "Rate.h"
#import "Spread.h"
#import "Time.h"

static NSString* const FXSExecutionOrdersTableName = @"execution_orders";

@interface ExecutionOrder ()
@property (nonatomic, readonly) NSUInteger saveSlot;
@property (nonatomic, readonly) CurrencyPair *currencyPair;
@property (nonatomic, readonly) PositionType *positionType;
@property (nonatomic, readonly) Rate *rate;
@property (nonatomic, readonly) PositionSize *positionSize;
@property (nonatomic, readonly) NSUInteger orderId;
@property (nonatomic) NSUInteger recordId;
@property (nonatomic, readonly) BOOL isNew;
@property (nonatomic, readonly) BOOL isClose;
@property (nonatomic, readonly) NSUInteger closeTargetExecutionOrderId;
@property (nonatomic, readonly) NSUInteger closeTargetOrderId;
@property (nonatomic, readonly) Rate *closeTargetRate;
@property (nonatomic, readonly) BOOL willExecuteOrder;
@property (nonatomic, readonly) OpenPosition *willExecuteCloseTargetOpenPosition;
@end

@implementation ExecutionOrder

+ (instancetype)orderWithBlock:(void (^)(ExecutionOrderComponents *))block
{
    ExecutionOrderComponents *components = [ExecutionOrderComponents new];
    
    block(components);
    
    return [[[self class] alloc] initWithComponents:components];
}

+ (NSArray *)allClosedOrdersOfCurrencyPair:(CurrencyPair *)currencyPair saveSlot:(NSUInteger)slot
{
    NSMutableArray *allOrders = [NSMutableArray array];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE save_slot = ? AND code = ? AND is_close = ?", FXSExecutionOrdersTableName];
    
    [self execute:^(FMDatabase *db) {
        
        FMResultSet *result = [db executeQuery:sql, @(slot), currencyPair.toCodeString, @(YES)];
        
        while ([result next]) {
            ExecutionOrder *order = [[ExecutionOrder alloc] initWithFMResultSet:result];
            [allOrders addObject:order];
        }
    }];
    
    return [allOrders copy];
}

+ (void)executionOrderDetail:(void (^)(CurrencyPair *currencyPair, PositionType *positionType, Rate *rate, NSUInteger orderId))block fromExecutionOrderId:(NSUInteger)executionOrderId saveSlot:(NSUInteger)slot
{
    if (!block) {
        return;
    }
    
    ExecutionOrder *order = [ExecutionOrder orderAtId:executionOrderId saveSlot:slot];
    
    if (order) {
        block(order.currencyPair, order.positionType, order.rate, order.orderId);
    }
}

+ (void)enumerateExecutionOrderDetail:(void (^)(CurrencyPair *currencyPair, PositionType *positionType, Rate *rate, NSUInteger executionOrderId, NSUInteger orderId))block fromExecutionOrderIds:(NSArray<NSNumber *> *)executionOrderIds saveSlot:(NSUInteger)slot
{
    if (!block || executionOrderIds.count == 0) {
        return;
    }
    
    NSArray<ExecutionOrder *> *orders = [self ordersAtIds:executionOrderIds saveSlot:slot];
    
    [orders enumerateObjectsUsingBlock:^(ExecutionOrder * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        block(obj.currencyPair, obj.positionType, obj.rate, obj.recordId, obj.orderId);
    }];
}

+ (ExecutionOrder *)orderAtId:(NSUInteger)recordId saveSlot:(NSUInteger)slot
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE id = ? AND save_slot = ?", FXSExecutionOrdersTableName];
    
    __block ExecutionOrder *order;
    
    [self execute:^(FMDatabase *db) {
        
        FMResultSet *result = [db executeQuery:sql, @(recordId), @(slot)];
        
        while ([result next]) {
            order = [[ExecutionOrder alloc] initWithFMResultSet:result];
        }
        
        [result close];
        
    }];
    
    return order;
}

+ (NSArray<ExecutionOrder *> *)ordersAtIds:(NSArray<NSNumber *> *)ids saveSlot:(NSUInteger)slot
{
    if (ids.count == 0) {
        return nil;
    }
    
    
    /* create sql */
    
    __block NSString *idsSql = @"";
    
    [ids enumerateObjectsUsingBlock:^(NSNumber * _Nonnull orderId, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *idSql = [NSString stringWithFormat:@"id = :%@", orderId.stringValue];
        if ((ids.count - 1) != idx) {
            idSql = [idSql stringByAppendingString:@" OR "];
        }
        idsSql = [idsSql stringByAppendingString:idSql];
    }];
    
    idsSql = [NSString stringWithFormat:@" ( %@ ) ", idsSql];
    
    
    
    NSString *saveSlotKey = @"save_slot";
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ AND save_slot = :%@", FXSExecutionOrdersTableName, idsSql, saveSlotKey];
    
    
    /* create parameter dictionary */
    
    NSMutableDictionary<NSString *, NSNumber *> *dic = [NSMutableDictionary dictionary];
    
    for (NSNumber *orderId in ids) {
        dic[orderId.stringValue] = orderId;
    }
    
    dic[saveSlotKey] = @(slot);
    
    
    /* db */
    
    __block NSMutableArray<ExecutionOrder *> *orders = [NSMutableArray array];
    
    [self execute:^(FMDatabase *db) {
        
        FMResultSet *result = [db executeQuery:sql withParameterDictionary:dic];
        
        while ([result next]) {
            ExecutionOrder *order = [[ExecutionOrder alloc] initWithFMResultSet:result];
            if (order) {
                [orders addObject:order];
            }
        }
        
        [result close];
        
    }];
    
    return [orders copy];
}

+ (Money *)profitAndLossOfCurrencyPair:(CurrencyPair *)currencyPair saveSlot:(NSUInteger)slot
{
    NSArray *allOrders = [self allClosedOrdersOfCurrencyPair:currencyPair saveSlot:slot];
    
    Money *profitAndLoss = [[Money alloc] initWithAmount:0 currency:currencyPair.quoteCurrency];
    
    for (ExecutionOrder *order in allOrders) {
        profitAndLoss = [profitAndLoss addMoney:[order profitAndLoss]];
    }
    
    return profitAndLoss;
}

+ (NSArray *)selectNewestFirstLimit:(NSUInteger)limit saveSlot:(NSUInteger)slot
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE save_slot = ? ORDER BY id DESC Limit ?", FXSExecutionOrdersTableName];
    
    NSMutableArray *array = [NSMutableArray array];
    
    [self execute:^(FMDatabase *db) {

        FMResultSet *result = [db executeQuery:sql, @(slot), @(limit)];
        
        while ([result next]) {
            ExecutionOrder *order = [[ExecutionOrder alloc] initWithFMResultSet:result];
            [array addObject:order];
        }
        
    }];
    
    return array;
}

+ (void)deleteSaveSlot:(NSUInteger)slot
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE save_slot = ?;", FXSExecutionOrdersTableName];
    
    [self execute:^(FMDatabase *db) {
        [db executeUpdate:sql, @(slot)];
    }];
}

- (instancetype)initWithComponents:(ExecutionOrderComponents *)components
{
    if (self = [self initWithSaveSlot:components.saveSlot CurrencyPair:components.currencyPair positionType:components.positionType rate:components.rate positionSize:components.positionSize]) {
        _recordId = components.recordId;
        _orderId = components.orderId;
        _isNew = components.isNew;
        _isClose = components.isClose;
        _closeTargetExecutionOrderId = components.closeTargetExecutionOrderId;
        _closeTargetOrderId = components.closeTargetOrderId;
        _closeTargetRate = components.closeTargetRate;
        _willExecuteOrder = components.willExecuteOrder;
        _willExecuteCloseTargetOpenPosition = components.willExecuteCloseTargetOpenPosition;
    }
    
    return self;
}

- (instancetype)initWithFMResultSet:(FMResultSet *)result
{
    NSUInteger saveSlot = [result intForColumn:@"save_slot"];
    CurrencyPair *currencyPair = [[CurrencyPair alloc] initWithCurrencyPairString:[result stringForColumn:@"code"]];
    Time *rateTime = [[Time alloc] initWithTimestamp:[result intForColumn:@"timestamp"]];
    Rate *rate = [[Rate alloc] initWithRateValue:[result doubleForColumn:@"rate"] currencyPair:currencyPair timestamp:rateTime];
    PositionType *positionType;
    Rate *closeTargetRate = [[Rate alloc] initWithRateValue:[result doubleForColumn:@"close_target_rate"] currencyPair:currencyPair timestamp:nil];
    
    if ([result boolForColumn:@"is_long"]) {
        positionType = [[PositionType alloc] initWithLong];
    } else if ([result boolForColumn:@"is_short"]) {
        positionType = [[PositionType alloc] initWithShort];
    }
    
    PositionSize *positionSize = [[PositionSize alloc] initWithSizeValue:[result intForColumn:@"position_size"]];
    
    return [[self class] orderWithBlock:^(ExecutionOrderComponents *components) {
        components.saveSlot = saveSlot;
        components.currencyPair = currencyPair;
        components.positionType = positionType;
        components.rate = rate;
        components.positionSize = positionSize;
        components.recordId = [result intForColumn:@"id"];
        components.orderId = [result intForColumn:@"order_id"];
        components.isNew = [result boolForColumn:@"is_new"];
        components.isClose = [result boolForColumn:@"is_close"];
        components.closeTargetExecutionOrderId = [result intForColumn:@"close_target_execution_order_id"];
        components.closeTargetOrderId = [result intForColumn:@"close_target_order_id"];
        components.closeTargetRate = closeTargetRate;
        components.willExecuteOrder = NO;
    }];
    
    return self;
}

- (void)execute
{
    if (self.isClose) {
        [self.willExecuteCloseTargetOpenPosition close];
        [self save];
    } else {
        [self save];
        OpenPosition *newOpenPosition = [OpenPosition openPositionWithBlock:^(OpenPositionComponents *components) {
            components.saveSlot = self.saveSlot;
            components.currencyPair = self.currencyPair;
            components.positionType = self.positionType;
            components.rate = self.rate;
            components.positionSize = self.positionSize;
            components.executionOrderId = self.recordId;
            components.isNewPosition = YES;
        }];
        [newOpenPosition new];
    }    
}

- (void)save
{
    if (![self validate]) {
        [NSException raise:@"ExecutionOrderException" format:@"Validate Error"];
    }
    
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ ( save_slot, order_id, code, is_short, is_long, rate, timestamp, position_size, is_close, close_target_execution_order_id, close_target_order_id, close_target_rate) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);", FXSExecutionOrdersTableName];
    
    [[self  class] execute:^(FMDatabase *db) {

        if([db executeUpdate:sql, @(self.saveSlot), @(self.orderId), self.currencyPair.toCodeString, @(self.positionType.isShort), @(self.positionType.isLong), self.rate.rateValueObj, self.rate.timestamp.timestampValueObj, self.positionSize.sizeValueObj, @(self.isClose), @(self.closeTargetExecutionOrderId), @(self.closeTargetOrderId), self.closeTargetRate.rateValueObj]) {
            
            NSString *sql = [NSString stringWithFormat:@"select MAX(id) as MAX_ID from %@ WHERE save_slot = ?;", FXSExecutionOrdersTableName];
            
            FMResultSet *result = [db executeQuery:sql, @(self.saveSlot)];
            
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
    if (!self.saveSlot || !self.willExecuteOrder || ![self.positionSize existsPosition]) {
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
    if (!self.isClose || self.willExecuteOrder) {
        return nil;
    }
    
    return [ProfitAndLossCalculator calculateByTargetRate:self.rate valuationRate:self.closeTargetRate positionSize:self.positionSize orderType:self.positionType];
}

#pragma mark - display

- (void)displayDataUsingBlock:(void (^)(NSString *currencyPair, NSString *positionType, NSString *rate, NSString *lot, NSString *orderId, NSString *closeTargetOrderId, NSString *profitAndLoss, NSString *ymdTime, NSString *hmsTime, UIColor *profitAndLossColor))block sizeOfLot:(PositionSize *)size displayCurrency:(Currency *)displayCurrency
{
    NSString *lot = [self.positionSize toLotFromPositionSizeOfLot:size].toDisplayString;
    
    NSString *closeTargetOrderId;
    NSString *profitAndLossString;
    
    Money *profitAndLoss = self.profitAndLoss;
    
    if (self.isClose) {
        closeTargetOrderId = @(self.closeTargetOrderId).stringValue;
        profitAndLossString = [profitAndLoss convertToCurrency:displayCurrency].toDisplayString;
    } else {
        closeTargetOrderId = @"";
        profitAndLossString = @"";
    }
    
    NSString *ymdTime = self.rate.timestamp.toDisplayYMDString;
    NSString *hmsTime = self.rate.timestamp.toDisplayHMSString;
    
    block(self.currencyPair.toDisplayString, self.positionType.toDisplayString, self.rate.toDisplayString, lot, @(self.orderId).stringValue, closeTargetOrderId, profitAndLossString, ymdTime, hmsTime, profitAndLoss.toDisplayColor);
    
}

#pragma mark - super

- (NSUInteger)saveSlot
{
    return _saveSlot;
}

- (CurrencyPair *)currencyPair
{
    return _currencyPair;
}

- (PositionType *)positionType
{
    return _positionType;
}

- (Rate *)rate
{
    return _rate;
}

- (PositionSize *)positionSize
{
    return _positionSize;
}

@end
