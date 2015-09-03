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
#import "Common.h"
#import "CurrencyConverter.h"
#import "CurrencyPair.h"
#import "ExecutionOrder.h"
#import "ForexHistoryData.h"
#import "Lot.h"
#import "Market.h"
#import "Money.h"
#import "OpenPositionRawRecord.h"
#import "Order.h"
#import "PositionSize.h"
#import "PositionType.h"
#import "ProfitAndLossCalculator.h"
#import "Rate.h"
#import "Rates.h"

static NSString* const FXSOpenPositionsTableName = @"open_positions";
static const int maxRecords = 50;

@interface OpenPosition ()
@property (nonatomic) NSUInteger recordId;
@property (nonatomic) NSUInteger executionOrderId;
@property (nonatomic) NSUInteger orderId;
@property (nonatomic) BOOL isNewPosition;
@end

@implementation OpenPosition

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

@end
