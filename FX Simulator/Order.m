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
#import "Money.h"
#import "NormalizedOrdersFactory.h"
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

@implementation Order {
    NormalizedOrdersFactory *_normalizedOrdersFactory;
}

+ (void)deleteSaveSlot:(NSUInteger)slot
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE save_slot = ?;", FXSOrdersTableName];
    
    [self execute:^(FMDatabase *db) {
        [db executeUpdate:sql, @(slot)];
    }];
}

- (instancetype)initWithSaveSlot:(NSUInteger)slot CurrencyPair:(CurrencyPair *)currencyPair positionType:(PositionType *)positionType rate:(Rate *)rate positionSize:(PositionSize *)positionSize normalizedOrdersFactory:(NormalizedOrdersFactory *)normalizedOrdersFactory
{
    if (!normalizedOrdersFactory) {
        return nil;
    }
    
    if (self = [super initWithSaveSlot:slot CurrencyPair:currencyPair positionType:positionType rate:rate positionSize:positionSize]) {
        _normalizedOrdersFactory = normalizedOrdersFactory;
    }
    
    return self;
}

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

- (instancetype)copyOrder
{
    Order *order = [[[self class] alloc] initWithSaveSlot:self.saveSlot CurrencyPair:self.currencyPair positionType:self.positionType rate:self.rate positionSize:self.positionSize normalizedOrdersFactory:_normalizedOrdersFactory];
    order.orderId = self.orderId;
    
    return order;
}

- (instancetype)copyOrderForNewOrder
{
    Order *order = [self copyOrder];
    order.isNew = YES;
    
    return order;
}

- (instancetype)copyOrderForCloseOrder
{
    Order *order = [self copyOrder];
    order.isClose = YES;
    
    return order;
}

- (instancetype)copyOrderForNewPositionSize:(PositionSize *)positionSize
{
    Order *order = [[[self class] alloc] initWithSaveSlot:self.saveSlot CurrencyPair:self.currencyPair positionType:self.positionType rate:self.rate positionSize:positionSize normalizedOrdersFactory:_normalizedOrdersFactory];
    order.orderId = self.orderId;
    
    return order;
}

- (NSArray<ExecutionOrder *> *)createExecutionOrders
{
    if (![self isExecutable]) {
        return nil;
    }
    
    NSArray<Order *> *normalizedOrders = [_normalizedOrdersFactory createNormalizedOrdersFromOrder:self];
    
    NSMutableArray<ExecutionOrder *> *executionOrders = [NSMutableArray array];
    
    for (Order *order in normalizedOrders) {
        if (order.isNew) {
            ExecutionOrder *newOrder = [order createNewExecutionOrder];
            if (newOrder) {
                [executionOrders addObject:newOrder];
            }
        } else if (order.isClose) {
            NSMutableArray<ExecutionOrder *> *closeExecutionOrders = [NSMutableArray array];
            closeExecutionOrders = [[order createCloseExecutionOrders] copy];
            if (0 < closeExecutionOrders.count) {
                [executionOrders addObjectsFromArray:closeExecutionOrders];
            }
        }
    }
    
    return [executionOrders copy];
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

- (NSArray<ExecutionOrder *> *)createCloseExecutionOrders
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
    
    if (![self.positionType isEqualPositionType:positionType]) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isExecutable
{
    if ((!self.isNew && !self.isClose) || _normalizedOrdersFactory) {
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

- (Money *)newPositionValue
{
    PositionSize *reverseTypePositionSize = [OpenPosition totalPositionSizeOfCurrencyPair:self.currencyPair positionType:[self.positionType reverseType] saveSlot:self.saveSlot];
    
    if (self.positionSize.sizeValue <= reverseTypePositionSize.sizeValue) {
        return [[Money alloc] initWithAmount:0 currency:self.rate.currencyPair.quoteCurrency];
    }
    
    return [[Money alloc] initWithAmount:(self.positionSize.sizeValue - reverseTypePositionSize.sizeValue) * self.rate.rateValue currency:self.rate.currencyPair.quoteCurrency];
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
