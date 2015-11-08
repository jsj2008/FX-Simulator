//
//  Order.m
//  FX Simulator
//
//  Created  on 2014/11/23.
//  
//

#import "Order.h"

#import "TradeDatabase+Protected.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "CurrencyPair.h"
#import "ExecutionOrder.h"
#import "ExecutionOrderComponents.h"
#import "OrdersCreateMode.h"
#import "OrdersCreateModeFactory.h"
#import "FXSAlert.h"
#import "Time.h"
#import "OpenPosition.h"
#import "PositionType.h"
#import "PositionSize.h"
#import "Rate.h"
#import "SimulationManager.h"
#import "Spread.h"

static NSString* const FXSOrdersTableName = @"orders";

@interface Order ()
@property (nonatomic, readonly) NSUInteger saveSlot;
@property (nonatomic, readonly) Rate *rate;
@property (nonatomic) NSUInteger orderId;
@property (nonatomic) BOOL isNew;
@property (nonatomic) BOOL isClose;
@end

@implementation Order

- (instancetype)initWithFMResultSet:(FMResultSet *)resultSet
{
    _saveSlot = [resultSet intForColumn:@"save_slot"];
    _orderId = [resultSet intForColumn:@"id"];
    
    if (!_saveSlot || _orderId < 1) {
        return nil;
    }
    
    if (self = [super init]) {
        
    }
    
    return self;
}

- (instancetype)copyOrderForNewPositionSize:(PositionSize *)positionSize
{
    Order *order = [[[self class] alloc] initWithSaveSlot:self.saveSlot CurrencyPair:self.currencyPair positionType:self.positionType rate:self.rate positionSize:positionSize];
    order.orderId = self.orderId;
    
    return order;
}

- (NSArray *)createExecutionOrders
{
    if (![self isExecutable]) {
        return nil;
    }
    
    NSMutableArray *orders = [NSMutableArray array];
    
    if (self.isNew) {
        ExecutionOrder *newOrder = [self createNewExecutionOrder];
        if (newOrder) {
            [orders addObject:newOrder];
        }
    } else if (self.isClose) {
        orders = [[self createCloseExecutionOrders] copy];
    }
    
    return [orders copy];
}

- (ExecutionOrder *)createNewExecutionOrder
{
    if (!self.isNew) {
        return nil;
    }
    
    if (![self save]) {
        return nil;
    }
    
    return [ExecutionOrder orderWithBlock:^(ExecutionOrderComponents *components) {
        components.saveSlot = self.saveSlot;
        components.currencyPair = self.currencyPair;
        components.positionType = self.positionType;
        components.rate = self.rate;
        components.positionSize = self.positionSize;
        components.orderId = self.orderId;
        components.isNew = YES;
        components.willExecuteOrder = YES;
    }];
}

- (NSArray *)createCloseExecutionOrders
{
    if (!self.isClose) {
        return nil;
    }
    
    if (![self save]) {
        return nil;
    }
    
    NSArray *openPositions = [OpenPosition selectCloseTargetOpenPositionsLimitClosePositionSize:self.positionSize closeTargetPositionType:[self.positionType reverseType] currencyPair:self.currencyPair saveSlot:self.saveSlot];
    
    NSMutableArray *executionOrders = [NSMutableArray array];
    
    for (OpenPosition *openPosition in openPositions) {
        ExecutionOrder *executionOrder = [openPosition createCloseExecutionOrderFromOrderId:self.orderId rate:self.rate];
        if (executionOrder) {
            [executionOrders addObject:executionOrder];
        }
    }

    return executionOrders;
}

- (BOOL)includeCloseOrder
{
    PositionType *positionType = [OpenPosition positionTypeOfCurrencyPair:self.currencyPair saveSlot:self.saveSlot];
    
    if (positionType == nil) {
        return NO;
    }
    
    if (![self.positionType isEqualOrderType:positionType]) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isExecutable
{
    if ((self.isNew && !self.isClose) || (!self.isNew && self.isClose)) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)save
{
    __block BOOL isSuccess;
    
    [[self class] execute:^(FMDatabase *db) {
        
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ ( save_slot, code, is_short, is_long, rate, timestamp, position_size, is_new, is_close ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)", FXSOrdersTableName];
        
        if([db executeUpdate:sql, @(self.saveSlot), self.currencyPair.toCodeString, @(self.positionType.isShort), @(self.positionType.isLong), self.rate.rateValueObj, self.rate.timestamp.timestampValueObj, self.positionSize.sizeValueObj, @(self.isNew), @(self.isClose)]) {
            
            NSString *sql = [NSString stringWithFormat:@"select MAX(id) as MAX_ID from %@;", FXSOrdersTableName];
            
            FMResultSet *result = [db executeQuery:sql];
            
            while ([result next]) {
                self.orderId = [result intForColumn:@"MAX_ID"];
            }
            
            isSuccess = YES;
            
        } else {
            isSuccess = NO;
        }

    }];
    
    return isSuccess;
}

- (void)setNewOrder
{
    if (self.isNew || self.isClose) {
        return;
    }
    
    self.isNew = YES;
}

- (void)setCloseOrder
{
    if (self.isNew || self.isClose) {
        return;
    }
    
    self.isClose = YES;
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
