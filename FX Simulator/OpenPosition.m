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
#import "ExecutionOrderComponents.h"
#import "ForexHistoryData.h"
#import "Lot.h"
#import "Market.h"
#import "Money.h"
#import "OpenPositionComponents.h"
#import "OpenPositionRawRecord.h"
#import "Order.h"
#import "PositionSize.h"
#import "PositionType.h"
#import "ProfitAndLossCalculator.h"
#import "Rate.h"
#import "Rates.h"
#import "Time.h"

static NSString* const FXSOpenPositionsTableName = @"open_positions";
static const int maxRecords = 50;

@interface OpenPosition ()
@property (nonatomic, readonly) NSUInteger saveSlot;
@property (nonatomic, readonly) CurrencyPair *currencyPair;
@property (nonatomic, readonly) PositionType *positionType;
@property (nonatomic, readonly) Rate *rate;
@property (nonatomic, readonly) PositionSize *positionSize;
@property (nonatomic, readonly) NSUInteger recordId;
@property (nonatomic, readonly) NSUInteger executionOrderId;
@property (nonatomic, readonly) NSUInteger orderId;
@property (nonatomic) BOOL isNewPosition;
@end

@implementation OpenPosition

+ (instancetype)openPositionWithBlock:(void (^)(OpenPositionComponents *components))block
{
    OpenPositionComponents *components = [OpenPositionComponents new];
    
    block(components);
    
    return [[[self class] alloc] initWithComponents:components];
}

+ (instancetype)createOpenPositionFromRawRecord:(OpenPositionRawRecord *)rawRecord
{    
    __block OpenPosition *openPosition;
    
    [ExecutionOrder executionOrderDetail:^(CurrencyPair *currencyPair, PositionType *positionType, Rate *rate, NSUInteger orderId) {
        
        openPosition = [self openPositionWithBlock:^(OpenPositionComponents *components) {
            components.saveSlot = rawRecord.saveSlot;
            components.currencyPair = currencyPair;
            components.positionType = positionType;
            components.rate = rate;
            components.positionSize = rawRecord.positionSize;
            components.recordId = rawRecord.recordId;
            components.executionOrderId = rawRecord.executionOrderId;
            components.orderId = orderId;
        }];
        
    } fromExecutionOrderId:rawRecord.executionOrderId saveSlot:rawRecord.saveSlot];
    
    return openPosition;
}

/**
 ポジションが新しい順
*/
+ (NSArray *)selectNewestFirstLimit:(NSUInteger)limit currencyPair:(CurrencyPair *)currencyPair saveSlot:(NSUInteger)slot
{
    NSArray *allPositions = [[self allOpenPositionRecordsOfCurrencyPair:currencyPair saveSlot:slot] reverseObjectEnumerator].allObjects;
    
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
+ (NSArray *)selectCloseTargetOpenPositionsLimitClosePositionSize:(PositionSize *)limitPositionSize closeTargetPositionType:(PositionType *)positionType currencyPair:(CurrencyPair *)currencyPair saveSlot:(NSUInteger)slot
{
    NSMutableArray *resultArray = [NSMutableArray array];
    
    NSArray *allPositions = [self allOpenPositionRecordsOfCurrencyPair:currencyPair saveSlot:slot];
    
    NSMutableArray *closeTargetPositions = [NSMutableArray array];
    
    for (OpenPosition *openPosition in allPositions) {
        if ([positionType isEqualPositionType:openPosition.positionType]) {
            [closeTargetPositions addObject:openPosition];
        }
    }
    
    position_size_t readTotalPositionSize = 0;
    
    for (OpenPosition *openPosition in closeTargetPositions) {
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
+ (NSArray *)selectAllOfSaveSlot:(NSUInteger)slot
{
    NSString *sql = [NSString stringWithFormat:@"select * from %@ WHERE save_slot = ?", FXSOpenPositionsTableName];
    
    NSMutableArray *openPositionRawRecords = [NSMutableArray array];
    
    [self execute:^(FMDatabase *db) {
        
        FMResultSet *rs;
        
        rs = [db executeQuery:sql, @(slot)];
        
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
+ (NSArray *)allOpenPositionRecordsOfCurrencyPair:(CurrencyPair *)currencyPair saveSlot:(NSUInteger)slot
{
    NSArray *allOpenPositions = [self selectAllOfSaveSlot:slot];
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (OpenPosition *openPosition in allOpenPositions) {
        if ([openPosition.currencyPair isEqualCurrencyPair:currencyPair]) {
            [array addObject:openPosition];
        }
    }
    
    return [array copy];
}

+ (PositionType *)positionTypeOfCurrencyPair:(CurrencyPair *)currencyPair saveSlot:(NSUInteger)slot
{
    // 両建て可能にしたときは、Long、Shortを比較して、多い方をPositionTypeにする。
    OpenPosition *openPosition = [self allOpenPositionRecordsOfCurrencyPair:currencyPair saveSlot:slot].firstObject;
    
    return openPosition.positionType;
}

+ (Money *)profitAndLossOfCurrencyPair:(CurrencyPair *)currencyPair ForMarket:(Market *)market InCurrency:(Currency *)currency saveSlot:(NSUInteger)slot
{
    PositionType *positionType = [self positionTypeOfCurrencyPair:currencyPair saveSlot:slot];
    
    Rates *valuationRates = [market currentRatesOfCurrencyPair:currencyPair];
    
    Rate *valuationRate;
    
    if ([positionType isShort]) {
        valuationRate = valuationRates.askRate;
    } else if ([positionType isLong]) {
        valuationRate = valuationRates.bidRate;
    } else {
        return [[Money alloc] initWithAmount:0 currency:currency];
    }
    
    PositionSize *totalPositionSize = [self totalPositionSizeOfCurrencyPair:currencyPair saveSlot:slot];
    Rate *averageRate = [self averageRateOfCurrencyPair:currencyPair saveSlot:slot];
    
    Money *profitAndLoss = [ProfitAndLossCalculator calculateByTargetRate:averageRate valuationRate:valuationRate positionSize:totalPositionSize orderType:positionType];
    
    return [profitAndLoss convertToCurrency:currency];
}

+ (PositionSize *)totalPositionSizeOfCurrencyPair:(CurrencyPair *)currencyPair saveSlot:(NSUInteger)slot
{
    NSArray *allOpenPositions = [self allOpenPositionRecordsOfCurrencyPair:currencyPair saveSlot:slot];
    
    position_size_t positionSize = 0;
    
    for (OpenPosition *openPosition in allOpenPositions) {
        positionSize += openPosition.positionSize.sizeValue;
    }
    
    return [[PositionSize alloc] initWithSizeValue:positionSize];
}

+ (PositionSize *)totalPositionSizeOfCurrencyPair:(CurrencyPair *)currencyPair positionType:(PositionType *)positionType saveSlot:(NSUInteger)slot
{
    NSArray *allOpenPositions = [self allOpenPositionRecordsOfCurrencyPair:currencyPair saveSlot:slot];
    
    position_size_t positionSize = 0;
    
    for (OpenPosition *openPosition in allOpenPositions) {
        if ([positionType isEqualPositionType:openPosition.positionType]) {
            positionSize += openPosition.positionSize.sizeValue;
        }
    }
    
    return [[PositionSize alloc] initWithSizeValue:positionSize];
}

+ (Rate *)averageRateOfCurrencyPair:(CurrencyPair *)currencyPair saveSlot:(NSUInteger)slot
{
    NSArray *allPositions = [self allOpenPositionRecordsOfCurrencyPair:currencyPair saveSlot:slot];
    PositionSize *totalPositionSize = [self totalPositionSizeOfCurrencyPair:currencyPair saveSlot:slot];
    
    rate_t averageRate = 0;
    
    for (OpenPosition *openPosition in allPositions) {
        averageRate += openPosition.rate.rateValue * openPosition.positionSize.sizeValue / totalPositionSize.sizeValue;
    }
    
    return [[Rate alloc] initWithRateValue:averageRate currencyPair:currencyPair timestamp:nil];
}

+ (BOOL)isExecutableNewPositionOfSaveSlot:(NSUInteger)slot
{
    if ([self countAllPositionsOfSaveSlot:slot] <= maxRecords) {
        return YES;
    } else {
        return NO;
    }
}

/**
 レコード数をカウント
*/
+ (NSUInteger)countAllPositionsOfSaveSlot:(NSUInteger)slot
{
    NSString *sql = [NSString stringWithFormat:@"select count(*) as count from %@ WHERE save_slot = ?;", FXSOpenPositionsTableName];
    
    __block NSUInteger count;
    
    [self execute:^(FMDatabase *db) {
        
        FMResultSet *rs = [db executeQuery:sql, @(slot)];
        
        while ([rs next]) {
            count  = [rs intForColumn:@"count"];
        }
    }];
    
    return count;
}

+ (void)deleteSaveSlot:(NSUInteger)slot
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE save_slot = ?;", FXSOpenPositionsTableName];
    
    [self execute:^(FMDatabase *db) {
        [db executeUpdate:sql, @(slot)];
    }];
}

- (instancetype)initWithComponents:(OpenPositionComponents *)components
{
    if (self = [self initWithSaveSlot:components.saveSlot CurrencyPair:components.currencyPair positionType:components.positionType rate:components.rate positionSize:components.positionSize]) {
        _recordId = components.recordId;
        _executionOrderId = components.executionOrderId;
        _orderId = components.orderId;
        _isNewPosition = components.isNewPosition;
    }
    
    return self;
}

- (ExecutionOrder *)createCloseExecutionOrderFromOrderId:(NSUInteger)orderId rate:(Rate *)rate
{
    if (!self.isExecutableClose) {
        return nil;
    }
    
    return [ExecutionOrder orderWithBlock:^(ExecutionOrderComponents *components) {
        components.saveSlot = self.saveSlot;
        components.currencyPair = self.currencyPair;
        components.positionType = [self.positionType reverseType];
        components.rate = rate;
        components.positionSize = self.positionSize;
        components.orderId = orderId;
        components.isClose = YES;
        components.willExecuteOrder = YES;
        components.closeTargetExecutionOrderId = self.executionOrderId;
        components.closeTargetOrderId = self.orderId;
        components.willExecuteCloseTargetOpenPosition = self;
    }];
}

- (void)setPositionSize:(PositionSize *)positionSize
{
    _positionSize = positionSize;
}

- (void)new
{    
    if ([self isNewPosition]) {
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (save_slot, execution_order_id, position_size) VALUES (?, ?, ?);", FXSOpenPositionsTableName];
        
        [[self class] execute:^(FMDatabase *db) {
            if ([db executeUpdate:sql, @(self.saveSlot), @(self.executionOrderId), self.positionSize.sizeValueObj]) {
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
        
        [[self class] execute:^(FMDatabase *db) {
            if (![db executeUpdate:sql, self.positionSize.sizeValueObj, @(self.recordId), @(self.saveSlot)]) {
                [NSException raise:@"OpenPositionException" format:@"DB Error: close failed"];
            }
        }];
    } else {
        [NSException raise:@"OpenPositionException" format:@"Close Error: open position is not close position"];
    }
}

- (BOOL)isExecutableClose
{
    if (self.recordId == 0 || self.isNewPosition) {
        return NO;
    } else {
        return YES;
    }
}

- (Money *)profitAndLossFromMarket:(Market *)market
{
    Rates *valuationRates = [market currentRatesOfCurrencyPair:self.currencyPair];
    
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

#pragma mark - display

- (void)displayDataUsingBlock:(void (^)(NSString *currencyPair, NSString *positionType, NSString *rate, NSString *lot, NSString *orderId, NSString *profitAndLoss, NSString *ymdTime, NSString *hmsTime, UIColor *profitAndLossColor))block market:(Market *)market sizeOfLot:(PositionSize *)size displayCurrency:(Currency *)displayCurrency
{
    NSString *lot = [self.positionSize toLotFromPositionSizeOfLot:size].toDisplayString;
    
    Money *profitAndLoss = [[self profitAndLossFromMarket:market] convertToCurrency:displayCurrency];
    
    NSString *ymdTime = self.rate.timestamp.toDisplayYMDString;
    NSString *hmsTime = self.rate.timestamp.toDisplayHMSString;
    
    block(self.currencyPair.toDisplayString, self.positionType.toDisplayString, self.rate.toDisplayString, lot, @(self.orderId).stringValue, profitAndLoss.toDisplayString, ymdTime, hmsTime, profitAndLoss.toDisplayColor);
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
