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

+ (void)executionOrderDetail:(void (^)(CurrencyPair *currencyPair, PositionType *positionType, Rate *rate, NSUInteger orderId))block fromExecutionOrderId:(NSUInteger)executionOrderId
{
    if (!block) {
        return;
    }
    
    ExecutionOrder *order = [ExecutionOrder orderAtId:executionOrderId];
    
    if (order) {
        block(order.currencyPair, order.positionType, order.rate, order.orderId);
    }
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

- (instancetype)initWithComponents:(ExecutionOrderComponents *)components
{
    if (self = [self initWithCurrencyPair:components.currencyPair positionType:components.positionType rate:components.rate positionSize:components.positionSize]) {
        _recordId = components.recordId;
        _orderId = components.orderId;
        _isNew = components.isNew;
        _isClose = components.isClose;
        _closeTargetExecutionOrderId = components.closeTargetExecutionOrderId;
        _closeTargetOrderId = components.closeTargetOrderId;
        _willExecuteOrder = components.willExecuteOrder;
        _willExecuteCloseTargetOpenPosition = components.willExecuteCloseTargetOpenPosition;
    }
    
    return self;
}

- (instancetype)initWithFMResultSet:(FMResultSet *)result
{
    CurrencyPair *currencyPair = [[CurrencyPair alloc] initWithCurrencyPairString:[result stringForColumn:@"code"]];
    Time *rateTime = [[Time alloc] initWithTimestamp:[result intForColumn:@"timestamp"]];
    Rate *rate = [[Rate alloc] initWithRateValue:[result doubleForColumn:@"rate"] currencyPair:currencyPair timestamp:rateTime];
    PositionType *positionType;
    
    if ([result boolForColumn:@"is_long"]) {
        positionType = [[PositionType alloc] initWithLong];
    } else if ([result boolForColumn:@"is_short"]) {
        positionType = [[PositionType alloc] initWithShort];
    }
    
    PositionSize *positionSize = [[PositionSize alloc] initWithSizeValue:[result intForColumn:@"position_size"]];
    
    return [[self class] orderWithBlock:^(ExecutionOrderComponents *components) {
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
    if (!self.willExecuteOrder || ![self.positionSize existsPosition]) {
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
    
    ExecutionOrder *closeTargetOrder = [[self class] orderAtId:self.closeTargetExecutionOrderId];
    
    if (!closeTargetOrder) {
        return nil;
    }
    
    return [ProfitAndLossCalculator calculateByTargetRate:self.rate valuationRate:closeTargetOrder.rate positionSize:self.positionSize orderType:self.positionType];
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
