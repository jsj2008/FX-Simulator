//
//  ForexData.m
//  ForexGame
//
//  Created  on 2014/03/23.
//  
//

#import "ForexHistory.h"

#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "FMResultSet.h"
#import "CurrencyPair.h"
#import "ForexDatabase.h"
#import "ForexDataChunk.h"
#import "ForexHistoryData.h"
#import "ForexHistoryUtils.h"
#import "Time.h"
#import "Rate.h"
#import "TimeFrame.h"

@implementation ForexHistory  {
    FMDatabaseQueue *_dbQueue;
    CurrencyPair *_currencyPair;
    TimeFrame *_timeScale;
    NSUInteger _timeScaleInt;
    NSString *_forexHistoryTableName;
}

- (instancetype)init
{
    if (self = [super init]) {
        _dbQueue = [ForexDatabase dbQueueConnect];
    }
    
    return self;
}

- (instancetype)initWithCurrencyPair:(CurrencyPair *)currencyPair timeScale:(TimeFrame *)timeScale
{
    if (currencyPair == nil || timeScale == nil) {
        DLog(@"CurrencyPair or TimeScale nil");
        return nil;
    }
    
    if (self = [self init]) {
        _currencyPair = currencyPair;
        _timeScale = timeScale;
        _timeScaleInt = timeScale.minute;
        _forexHistoryTableName = [ForexHistoryUtils createTableName:_currencyPair.toCodeString timeScale:_timeScaleInt];
    }
    
    return self;
}

- (ForexHistoryData *)nextDataOfTime:(Time *)time
{
    NSString *sql = [NSString stringWithFormat:@"SELECT rowid,* FROM %@ WHERE ? < close_minute_close_timestamp ORDER BY close_minute_close_timestamp ASC LIMIT 1", _forexHistoryTableName];
    
    __block ForexHistoryData *nextData;
    
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *results = [db executeQuery:sql, time.timestampValueObj];
        
        while ([results next]) {
            nextData = [[ForexHistoryData alloc] initWithFMResultSet:results currencyPair:_currencyPair timeScale:_timeScale];
        }
    }];
    
    return nextData;
}

- (ForexDataChunk *)selectBaseTime:(Time *)time frontLimit:(NSUInteger)frontLimit backLimit:(NSUInteger)backLimit
{
    NSString *getFrontDataSql = [NSString stringWithFormat:@"SELECT rowid,* FROM (SELECT rowid,* FROM %@ WHERE ? <= close_minute_close_timestamp ORDER BY close_minute_close_timestamp ASC LIMIT ?) ORDER BY close_minute_close_timestamp DESC", _forexHistoryTableName];
    NSString *getBackDataSql = [NSString stringWithFormat:@"SELECT rowid,* FROM %@ WHERE close_minute_close_timestamp < ? ORDER BY close_minute_close_timestamp DESC LIMIT ?", _forexHistoryTableName];
    
    NSMutableArray *frontArray = [NSMutableArray array];
    NSMutableArray *backArray = [NSMutableArray array];
    
    [_dbQueue inDatabase:^(FMDatabase *db) {
        
        /* get front array */
        
        //if (0 < frontLimit) {
        
        FMResultSet *results = [db executeQuery:getFrontDataSql, time.timestampValueObj, @(frontLimit+1)]; // +1 基準となる時間(time)のデータ自身を含む。
        
        while ([results next]) {
            ForexHistoryData *data = [[ForexHistoryData alloc] initWithFMResultSet:results currencyPair:_currencyPair timeScale:_timeScale];
            [frontArray addObject:data];
        }
        
        //}
        
        /* get back array */
        
        //if (0 < backLimit) {
        
        FMResultSet *results2 = [db executeQuery:getBackDataSql, time.timestampValueObj, @(backLimit)];
        
        while ([results2 next]) {
            ForexHistoryData *data = [[ForexHistoryData alloc] initWithFMResultSet:results2 currencyPair:_currencyPair timeScale:_timeScale];
            [backArray addObject:data];
        }
        
        //}
    
    }];
    
    NSArray *array = [[frontArray arrayByAddingObjectsFromArray:backArray] copy];
    
    return [[ForexDataChunk alloc] initWithSortedForexDataArray:array];
}

- (ForexDataChunk *)selectMaxCloseTime:(Time *)closeTime limit:(NSUInteger)limit
{
    NSString *sql = [NSString stringWithFormat:@"SELECT rowid,* FROM %@ WHERE close_minute_close_timestamp <= ? ORDER BY close_minute_close_timestamp DESC LIMIT ?", _forexHistoryTableName];
    
    NSMutableArray *array = [NSMutableArray array];
    
    [_dbQueue inDatabase:^(FMDatabase *db) {
        
        FMResultSet *results = [db executeQuery:sql, closeTime.timestampValueObj, @(limit)];
        
        while ([results next]) {
            ForexHistoryData *data = [[ForexHistoryData alloc] initWithFMResultSet:results currencyPair:_currencyPair timeScale:_timeScale];
            [array addObject:data];
        }
        
    }];
    
    return [[ForexDataChunk alloc] initWithSortedForexDataArray:array];
}

- (ForexDataChunk *)selectMaxCloseTime:(Time *)closeTime newerThan:(Time *)oldCloseTime
{
    NSString *sql = [NSString stringWithFormat:@"SELECT rowid,* FROM %@ WHERE close_minute_close_timestamp <= ? AND ? < close_minute_close_timestamp ORDER BY close_minute_close_timestamp DESC", _forexHistoryTableName];
    
    NSMutableArray *array = [NSMutableArray array];
    
    [_dbQueue inDatabase:^(FMDatabase *db) {
        
        FMResultSet *results = [db executeQuery:sql, closeTime.timestampValueObj, oldCloseTime.timestampValueObj];
        
        while ([results next]) {
            ForexHistoryData *data = [[ForexHistoryData alloc] initWithFMResultSet:results currencyPair:_currencyPair timeScale:_timeScale];
            [array addObject:data];
        }
        
    }];
    
    return [[ForexDataChunk alloc] initWithForexDataArray:array];
}

- (Time *)minOpenTime
{
    return [self oldestData].open.timestamp;
}

- (Time *)maxOpenTime
{
    return [self newestData].close.timestamp;
}

- (ForexHistoryData *)oldestData
{
    NSString *sql = [NSString stringWithFormat:@"select rowid,* from %@ limit 1;", _forexHistoryTableName];
    
    __block ForexHistoryData *data;
    
    [_dbQueue inDatabase:^(FMDatabase *db) {
        
        FMResultSet *results = [db executeQuery:sql];
        
        while ([results next]) {
            data = [[ForexHistoryData alloc] initWithFMResultSet:results currencyPair:_currencyPair timeScale:_timeScale];
        }
        
    }];
    
    return data;
}

- (ForexHistoryData *)newestData
{
    NSString *sql = [NSString stringWithFormat:@"select rowid,* from %@ order by rowid desc limit 1;", _forexHistoryTableName];
    
    __block ForexHistoryData *data;
    
    [_dbQueue inDatabase:^(FMDatabase *db) {
        
        FMResultSet *results = [db executeQuery:sql];
        
        while ([results next]) {
            data = [[ForexHistoryData alloc] initWithFMResultSet:results currencyPair:_currencyPair timeScale:_timeScale];
        }
        
    }];
    
    return data;
}

@end
