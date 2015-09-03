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
#import "FXSAlert.h"
#import "CurrencyPair.h"
#import "ExecutionOrder.h"
#import "ExecutionOrdersCreateMode.h"
#import "ExecutionOrdersCreateModeFactory.h"
#import "MarketTime.h"
#import "OpenPosition.h"
#import "PositionType.h"
#import "PositionSize.h"
#import "Rate.h"
#import "SimulationManager.h"
#import "Spread.h"

static NSString* const FXSOrdersTableName = @"orders";

@interface Order ()
@property (nonatomic) NSUInteger orderId;
@property (nonatomic, readonly) BOOL isNew;
@property (nonatomic, readonly) BOOL isClose;
@end

@implementation Order

- (instancetype)initWithFMResultSet:(FMResultSet *)resultSet
{    
    _orderId = [resultSet intForColumn:@"id"];
    
    if (_orderId < 1) {
        return nil;
    }
    
    if (self = [super init]) {
        
    }
    
    return self;
}

- (instancetype)copyOrderNewPositionSize:(PositionSize *)positionSize
{
    Order *order = [self initWithCurrencyPair:self.currencyPair positionType:self.positionType rate:self.rate positionSize:positionSize];
    order.orderId = self.orderId;
    
    return order;
}

- (void)execute
{
    SimulationManager *simulationManager = [SimulationManager sharedSimulationManager];
    
    if (![simulationManager isExecutableOrder]) {
        return;
    }
    
    if (![OpenPosition isExecutableNewPosition]) {
        [FXSAlert showAlertTitle:@"Max Open Position" message:nil controller:self.alertTargetController];
        return;
    }
    
    [self save];
    
    ExecutionOrdersCreateModeFactory *factory = [ExecutionOrdersCreateModeFactory new];
    
    ExecutionOrdersCreateMode *createMode = [factory createModeFromOrder:self];
    
    NSArray *executionOrders = [createMode create:self];
    
    @try {
        [[self class] transaction:^{
            for (ExecutionOrder *order in executionOrders) {
                [order execute];
            }
        }];
    }
    @catch (NSException *exception) {
        [FXSAlert showAlertTitle:exception.name message:exception.reason controller:self.alertTargetController];
    }
    @finally {
        
    }

}

- (BOOL)includeCloseOrder
{
    PositionType *positionType = [OpenPosition positionTypeOfCurrencyPair:self.currencyPair];
    
    if (positionType == nil) {
        return NO;
    }
    
    if (![self.positionType isEqualOrderType:positionType]) {
        return YES;
    } else {
        return NO;
    }
}

- (void)save
{
    [[self class] execute:^(FMDatabase *db, NSUInteger saveSlot) {
        
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ ( save_slot, code, is_short, is_long, rate, timestamp, position_size, is_new, is_close ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)", FXSOrdersTableName];
        
        if([db executeUpdate:sql, @(saveSlot), self.currencyPair.toCodeString, @(self.positionType.isShort), @(self.positionType.isLong), self.rate.rateValueObj, self.rate.timestamp.timestampValueObj, self.positionSize.sizeValueObj, @(self.isNew), @(self.isClose)]) {
            
            NSString *sql = [NSString stringWithFormat:@"select MAX(id) as MAX_ID from %@;", FXSOrdersTableName];
            
            FMResultSet *result = [db executeQuery:sql];
            
            while ([result next]) {
                self.orderId = [result intForColumn:@"MAX_ID"];
            }
            
        }

    }];
}

@end
