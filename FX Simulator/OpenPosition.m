//
//  SQLiteOpenPositionModel.m
//  FX Simulator
//
//  Created  on 2014/09/09.
//  
//

#import "OpenPosition.h"

#import "TradeDatabase+Protected.h"
#import "FMDatabase.h"
#import "OpenPositionUtils.h"
#import "OpenPositionRawRecord.h"
#import "Order.h"
#import "PositionSize.h"
#import "PositionType.h"
#import "Lot.h"
#import "Rate.h"
#import "Rates.h"
#import "ProfitAndLossCalculator.h"
#import "Common.h"
#import "PositionSize.h"
#import "ExecutionOrder.h"
#import "CurrencyConverter.h"
#import "Market.h"
#import "Money.h"
#import "ForexHistoryData.h"
#import "CurrencyPair.h"

static NSString* const FXSOpenPositionsTableName = @"open_positions";
static const int maxRecords = 50;

@interface OpenPosition ()

@property (nonatomic) NSUInteger recordId;
@property (nonatomic) NSUInteger executionOrderId;
@property (nonatomic) NSUInteger orderId;
@property (nonatomic) BOOL isNewPosition;

@end

@implementation OpenPosition

//@dynamic positionSize;

/*- (instancetype)initWithSaveSlotNumber:(NSUInteger)slotNumber orderHistory:(OrderHistory *)orderHistory db:(FMDatabase *)db
{
    if (self = [super init]) {
        _tradeDatabase = db;
        _saveSlotNumber = slotNumber;
        _orderHistory = orderHistory;
        
        [self update];
    }
    
    return self;
}*/

/*- (instancetype)initWithSaveSlotNumber:(NSUInteger)slotNumber executionHistory:(ExecutionHistory *)executionHistory db:(FMDatabase *)db
{
    if (self = [super init]) {
        _tradeDatabase = db;
        _saveSlotNumber = slotNumber;
        _executionHistory = executionHistory;
        
        [self update];
    }
    
    return self;
}*/

/*-(void)update
{
    _allRecords = [self selectAll];
}*/

+ (instancetype)createNewOpenPositionFromExecutionOrder:(ExecutionOrder *)order executionOrderId:(NSUInteger)executionOrderId
{
    OpenPosition *newOpenPosition = [[[self class] alloc] initWithCurrencyPair:order.currencyPair positionType:order.positionType rate:order.rate positionSize:order.positionSize];
    newOpenPosition.recordId = 0;
    newOpenPosition.executionOrderId = executionOrderId;
    newOpenPosition.isNewPosition = YES;
    
    return newOpenPosition;
}

+ (instancetype)createOpenPositionFromRawRecord:(OpenPositionRawRecord *)rawRecord
{
    NSUInteger executionOrderId = rawRecord.executionOrderId;
    
    ExecutionOrder *order = [ExecutionOrder orderAtId:executionOrderId];
    
    if (!order) {
        return nil;
    }
    
    PositionSize *openPositionSize = rawRecord.positionSize;
    
    OpenPosition *openPosition = [[[self class] alloc] initWithCurrencyPair:order.currencyPair positionType:order.positionType rate:order.rate positionSize:openPositionSize];
    openPosition.recordId = rawRecord.recordId;
    openPosition.executionOrderId = rawRecord.executionOrderId;
    openPosition.orderId = order.orderId;
    openPosition.isNewPosition = NO;
    
    return openPosition;
}

/**
 ポジションが新しい順
*/
+ (NSArray *)selectNewestFirstLimit:(NSUInteger)limit currencyPair:(CurrencyPair *)currencyPair
{
    NSArray *allPositions = [[self allOpenPositionRecordsOfCurrencyPair:currencyPair] reverseObjectEnumerator].allObjects;
    
    NSUInteger len;
    
    if (allPositions.count < limit) {
        len = allPositions.count;
    } else {
        len = limit;
    }
    
    NSArray *selectArray = [allPositions subarrayWithRange:NSMakeRange(0, len)];
    
    return selectArray;
}

#warning Limit(OpenPositionViewController);
+ (NSArray *)selectLatestDataLimit:(NSNumber *)num
{
    NSArray *all = [self selectAll];
    
    //return [[[all reverseObjectEnumerator] allObjects] subarrayWithRange:NSMakeRange(0,  num.unsignedIntegerValue)];
    return [[all reverseObjectEnumerator] allObjects];
}

/**
 ポジションが古い順
*/
+ (NSArray *)selectCloseTargetOpenPositionsLimitClosePositionSize:(PositionSize *)limitPositionSize currencyPair:(CurrencyPair *)currencyPair
{
    NSMutableArray *resultArray = [NSMutableArray array];
    
    NSArray *allPositions = [self allOpenPositionRecordsOfCurrencyPair:currencyPair];
    
    position_size_t readTotalPositionSize = 0;
    
    for (OpenPosition *openPosition in allPositions) {
        readTotalPositionSize += openPosition.positionSize.sizeValue;
        
        // selectサイズ以上のオープンポジションを読み込んだとき
        if (limitPositionSize.sizeValue <= readTotalPositionSize) {
            /*
             読み込んだサイズの合計と、selectサイズがちょうど同じならそのまま追加
             読み込んだサイズの方が大きければ、selectサイズより多い部分をカットして、
             そのオープンポジションの一部分をクローズ対象として追加
             */
            if (limitPositionSize.sizeValue == readTotalPositionSize) {
                [resultArray addObject:openPosition];
                break;
            } else if (limitPositionSize.sizeValue < readTotalPositionSize) {
                position_size_t closePositionSize = openPosition.positionSize.sizeValue - (readTotalPositionSize - limitPositionSize.sizeValue);
                openPosition.positionSize = [[PositionSize alloc] initWithSizeValue:closePositionSize];
                [resultArray addObject:openPosition];
                break;
            }
        } else {
            [resultArray addObject:openPosition];
        }
    }
    
    return [resultArray copy];
}

/** 
 ポジションが古い順
*/
+ (NSArray *)selectAll
{
    NSString *sql = [NSString stringWithFormat:@"select * from %@ WHERE save_slot = ?", FXSOpenPositionsTableName];
    
    NSMutableArray *openPositionRawRecords = [NSMutableArray array];
    
    [self execute:^(FMDatabase *db, NSUInteger saveSlot) {
        
        FMResultSet *rs;
        
        rs = [db executeQuery:sql, @(saveSlot)];
        
        while ([rs next]) {
            OpenPositionRawRecord *openPositionRawRecord = [[OpenPositionRawRecord alloc] initWithFMResultSet:rs];
            
            // ポジションサイズが０以上のものだけOpenPositionにする
            if (0 < openPositionRawRecord.positionSize.sizeValue) {
                [openPositionRawRecords addObject:openPositionRawRecord];
            }
        }
        
        /*while ([rs next]) {
            OpenPosition *openPosition = [[self alloc] initWithFMResultSet:rs];
            
            // ポジションサイズが０以上のものだけOpenPositionにする
            if (0 < openPosition.positionSize.sizeValue) {
                [openPositions addObject:openPosition];
            }
        }*/
        
        [rs close];

    }];
    
    
    
    NSMutableArray *openPositions = [NSMutableArray array];
    
    [openPositionRawRecords enumerateObjectsUsingBlock:^(OpenPositionRawRecord *obj, NSUInteger idx, BOOL *stop) {
        OpenPosition *openPosition = [self createOpenPositionFromRawRecord:obj];
        if (openPosition) {
            [openPositions addObject:openPosition];
        }
    }];
    
    return openPositions;
}

/**
 ポジションが古い順
*/
+ (NSArray *)allOpenPositionRecordsOfCurrencyPair:(CurrencyPair *)currencyPair
{
    NSArray *allOpenPositions = [self selectAll];
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (OpenPosition *openPosition in allOpenPositions) {
        if ([openPosition.currencyPair isEqualCurrencyPair:currencyPair]) {
            [array addObject:openPosition];
        }
    }
    
    return [array copy];
}

+ (PositionType *)positionTypeOfCurrencyPair:(CurrencyPair *)currencyPair
{
    // 両建て可能にしたときは、Long、Shortを比較して、多い方をPositionTypeにする。
    OpenPosition *openPosition = [self allOpenPositionRecordsOfCurrencyPair:currencyPair].firstObject;
    
    return openPosition.positionType;
}

+ (Money *)profitAndLossOfCurrencyPair:(CurrencyPair *)currencyPair ForMarket:(Market *)market InCurrency:(Currency *)currency
{
    PositionType *positionType = [self positionTypeOfCurrencyPair:currencyPair];
    
    Rates *valuationRates = [market getCurrentRatesOfCurrencyPair:currencyPair];
    
    Rate *valuationRate;
    
    if ([positionType isShort]) {
        valuationRate = valuationRates.askRate;
    } else if ([positionType isLong]) {
        valuationRate = valuationRates.bidRate;
    } else {
        return [[Money alloc] initWithAmount:0 currency:currency];
    }
    
    PositionSize *totalPositionSize = [self totalPositionSizeOfCurrencyPair:currencyPair];
    Rate *averageRate = [self averageRateOfCurrencyPair:currencyPair];
    
    Money *profitAndLoss = [ProfitAndLossCalculator calculateByTargetRate:averageRate valuationRate:valuationRate positionSize:totalPositionSize orderType:positionType];
    
    return [profitAndLoss convertToCurrency:currency];
}

+ (PositionSize *)totalPositionSizeOfCurrencyPair:(CurrencyPair *)currencyPair
{
    NSArray *allOpenPositions = [self allOpenPositionRecordsOfCurrencyPair:currencyPair];
    
    position_size_t positionSize = 0;
    
    for (OpenPosition *openPosition in allOpenPositions) {
        positionSize += openPosition.positionSize.sizeValue;
    }
    
    return [[PositionSize alloc] initWithSizeValue:positionSize];
}

+ (Lot *)totalLotOfCurrencyPair:(CurrencyPair *)currencyPair
{
    return [[self totalPositionSizeOfCurrencyPair:currencyPair] toLot];
}

+ (Rate *)averageRateOfCurrencyPair:(CurrencyPair *)currencyPair
{
    NSArray *allPositions = [self allOpenPositionRecordsOfCurrencyPair:currencyPair];
    PositionSize *totalPositionSize = [self totalPositionSizeOfCurrencyPair:currencyPair];
    
    rate_t averageRate = 0;
    
    for (OpenPosition *openPosition in allPositions) {
        averageRate += openPosition.rate.rateValue * openPosition.positionSize.sizeValue / totalPositionSize.sizeValue;
    }
    
    return [[Rate alloc] initWithRateValue:averageRate currencyPair:currencyPair timestamp:nil];
}

+ (BOOL)isExecutableNewPosition
{
    if ([self countAllPositions] <= maxRecords) {
        return YES;
    } else {
        return NO;
    }
}

/**
 レコード数をカウント
*/
+ (NSUInteger)countAllPositions
{
    NSString *sql = [NSString stringWithFormat:@"select count(*) as count from %@;", FXSOpenPositionsTableName];
    
    __block NSUInteger count;
    
    [self execute:^(FMDatabase *db, NSUInteger saveSlot) {
        
        FMResultSet *rs = [db executeQuery:sql];
        
        while ([rs next]) {
            count  = [rs intForColumn:@"count"];
        }
    }];
    
    return count;
}

/*- (instancetype)initWithFMResultSet:(FMResultSet *)result
{
    NSUInteger executionOrderId = [result intForColumn:@"execution_order_id"];
    
    ExecutionOrder *order = [ExecutionOrder orderAtId:executionOrderId];
    
    if (!order) {
        return nil;
    }
    
    PositionSize *openPositionSize = [[PositionSize alloc] initWithSizeValue:[result intForColumn:@"position_size"]];
    
    if (self = [super initWithCurrencyPair:order.currencyPair positionType:order.positionType rate:order.rate positionSize:openPositionSize]) {
        _recordId = [result intForColumn:@"id"];
        _executionOrderId = executionOrderId;
        _orderId = order.orderId;
        self.isNewPosition = NO;
    }
    
    return self;
}*/

- (void)setPositionSize:(PositionSize *)positionSize
{
    _positionSize = positionSize;
}

- (void)new
{    
    if ([self isNewPosition]) {
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (save_slot, execution_order_id, position_size) VALUES (?, ?, ?);", FXSOpenPositionsTableName];
        
        [[self class] execute:^(FMDatabase *db, NSUInteger saveSlot) {
            if ([db executeUpdate:sql, @(saveSlot), @(self.executionOrderId), self.positionSize.sizeValueObj]) {
                self.isNewPosition = NO;
            } else {
                [NSException raise:@"OpenPositionException" format:@"DB Error: new failed"];
            }
        }];
    } else {
        [NSException raise:@"OpenPositionException" format:@"Close Error: open position is not new position"];
    }
}

- (void)close
{
    if (![self isNewPosition]) {
        
        // position_sizeが0になっても、deleteしない
        NSString *sql = [NSString stringWithFormat:@"update %@ set position_size = position_size - ? where id = ? AND save_slot = ?", FXSOpenPositionsTableName];
        
        [[self class] execute:^(FMDatabase *db, NSUInteger saveSlot) {
            if (![db executeUpdate:sql, self.positionSize.sizeValueObj, @(self.recordId), @(saveSlot)]) {
                [NSException raise:@"OpenPositionException" format:@"DB Error: close failed"];
            }
        }];
    } else {
        [NSException raise:@"OpenPositionException" format:@"Close Error: open position is not close position"];
    }
}

/*- (void)save
{
    if ([self isNewPosition]) {
        
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (save_slot, execution_order_id, position_size) VALUES (?, ?, ?);", FXSOpenPositionsTableName];
        
        [[self class] execute:^(FMDatabase *db, NSUInteger saveSlot) {
            if ([db executeUpdate:sql, @(saveSlot), @(self.executionOrderId), self.positionSize.sizeValueObj]) {
                self.isNewPosition = NO;
            }
        }];
        
    } else {
        
        NSString *sql = [NSString stringWithFormat:@"update %@ set position_size = ? where id = ? AND save_slot = ?", FXSOpenPositionsTableName];
        
        [[self class] execute:^(FMDatabase *db, NSUInteger saveSlot) {
            [db executeQuery:sql, self.positionSize.sizeValueObj, @(self.recordId), @(saveSlot)];
        }];
        
    }
}*/

- (BOOL)isNewPosition
{
    if (self.recordId == 0 && _isNewPosition) {
        return YES;
    } else {
        return NO;
    }
}

- (Money *)profitAndLossFromMarket:(Market *)market
{
    Rates *valuationRates = [market getCurrentRatesOfCurrencyPair:self.currencyPair];
    
    Rate *valuationRate;
    
    if ([self.positionType isShort]) {
        valuationRate = valuationRates.askRate;
    } else if ([self.positionType isLong]) {
        valuationRate = valuationRates.bidRate;
    } else {
        return nil;
    }
    
    Money *profitAndLoss = [ProfitAndLossCalculator calculateByTargetRate:self.rate valuationRate:valuationRate positionSize:self.positionSize orderType:self.positionType];
    
    return profitAndLoss;
}

/*- (void)delete
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE id = ? AND save_slot = ?;", FXSOpenPositionsTableName];
    
    [[self class] execute:^(FMDatabase *db, NSUInteger saveSlot) {
        [db executeUpdate:sql, @(self.recordId), @(saveSlot)];
    }];
}*/

#pragma mark - execute orders

/*-(BOOL)execute:(NSArray *)orders db:(FMDatabase *)db
{
    if (!self.inExecutionOrdersTransaction) {
        return NO;
    }
    
    BOOL isSuccess;
    
    for (ExecutionOrder *order in orders) {
        if (order.isClose) {
            isSuccess = [self closeOpenPosition:order db:db];
        } else {
            isSuccess = [self newOpenPosition:order db:db];
        }
        
        if (!isSuccess) {
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)closeOpenPosition:(ExecutionOrder *)closeOrder db:(FMDatabase *)db
{
    return [self updateOpenPositionNumber:closeOrder.closeTargetOpenPositionId closePositionSize:closeOrder.positionSize db:db];
}

- (BOOL)newOpenPosition:(ExecutionOrder *)newOrder db:(FMDatabase *)db
{
    return [self saveOpenPositionRawRecordFromNewExecutionOrder:newOrder db:db];
}

-(BOOL)deleteOpenPositionNumber:(int)num db:(FMDatabase *)db
{
    NSString *sql = [NSString stringWithFormat:@"delete from %@ where id = ? AND save_slot = ?", FXSOpenPositionTableName];
    
    if(![db executeUpdate:sql, @(num), @(_saveSlotNumber)]) {
        return false;
    }
    
    return true;
}

-(BOOL)updateOpenPositionNumber:(int)number closePositionSize:(PositionSize*)positionSsize db:(FMDatabase *)db
{
    // PositionSizeが0のRecordはそのままにしておく　OpenPositionでRecordを取得するときは0以上のものだけ取得
    
    NSString *sql = [NSString stringWithFormat:@"update %@ set open_position_size = open_position_size - ? where id = ? AND save_slot = ?", FXSOpenPositionTableName];
    
    if(![db executeUpdate:sql, positionSsize.sizeValueObj, @(number), @(_saveSlotNumber)]) {
        return false;
    }
    
    return true;
}

-(BOOL)saveOpenPositionRawRecordFromNewExecutionOrder:(ExecutionOrder *)order db:(FMDatabase *)db
{
    NSString *sql = [NSString stringWithFormat:@"insert into %@ (save_slot, order_history_id, execution_history_id, open_position_size) values (?, ?, ?, ?);", FXSOpenPositionTableName];
    
    if([db executeUpdate:sql, @(_saveSlotNumber), @(order.orderHistoryId), @(order.executionHistoryId), order.positionSize.sizeValueObj]) {
        return YES;
    } else {
        return NO;
    }
    
}*/

@end
