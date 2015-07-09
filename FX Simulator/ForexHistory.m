//
//  ForexData.m
//  ForexGame
//
//  Created  on 2014/03/23.
//  
//

#import "ForexHistory.h"

#import "MarketTime.h"
#import "MarketTimeScale.h"
#import "ForexDatabase.h"
#import "ForexDataChunk.h"
#import "ForexHistoryData.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "CurrencyPair.h"
#import "ForexHistoryData.h"
#import "ForexHistoryCacheConfig.h"
#import "ForexHistoryCache.h"
#import "ForexHistoryUtils.h"
#import "Rate.h"



static const int cacheSize = 300;

@implementation ForexHistory  {
    FMDatabase *forexDatabase;
    ForexHistoryCache *cache;
    CurrencyPair *_currencyPair;
    MarketTimeScale *_timeScale;
    int _timeScaleInt;
    NSString *_forexHistoryTableName;
}

-(id)init
{
    if (self = [super init]) {
        forexDatabase = [ForexDatabase dbConnect];
        cache = [[ForexHistoryCache alloc] initWithCacheSize:cacheSize];
    }
    
    return self;
}

-(id)initWithCurrencyPair:(CurrencyPair *)currencyPair timeScale:(MarketTimeScale*)timeScale
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

- (ForexDataChunk *)selectBaseData:(ForexHistoryData *)data frontLimit:(NSUInteger)frontLimit backLimit:(NSUInteger)backLimit
{
    //NSString *sql = [NSString stringWithFormat:@"SELECT rowid,* FROM %@ WHERE ? <= close_minute_close_timestamp ORDER BY close_minute_close_timestamp ASC LIMIT ?", _forexHistoryTableName];
    //NSString *sql2 = [NSString stringWithFormat:@"SELECT rowid,* FROM %@ WHERE close_minute_close_timestamp < ? ORDER BY close_minute_close_timestamp DESC LIMIT ?", _forexHistoryTableName];
    NSString *getFrontDataSql = [NSString stringWithFormat:@"SELECT rowid,* FROM (SELECT rowid,* FROM %@ WHERE ? <= close_minute_close_timestamp ORDER BY close_minute_close_timestamp ASC LIMIT ?) ORDER BY close_minute_close_timestamp DESC", _forexHistoryTableName];
    NSString *getBackDataSql = [NSString stringWithFormat:@"SELECT rowid,* FROM %@ WHERE close_minute_close_timestamp < ? ORDER BY close_minute_close_timestamp DESC LIMIT ?", _forexHistoryTableName];
    
    [forexDatabase open];
    
    /* get front array */
    
    FMResultSet *results = [forexDatabase executeQuery:getFrontDataSql, data.close.timestamp.timestampValueObj, @(frontLimit+1)]; // +1 基準となるデータ自身を含む。
    
    NSMutableArray *frontArray = [NSMutableArray array];
    
    while ([results next]) {
        ForexHistoryData *data = [[ForexHistoryData alloc] initWithFMResultSet:results currencyPair:_currencyPair timeScale:_timeScale];
        [frontArray addObject:data];
    }
    
    /* get back array */
    
    FMResultSet *results2 = [forexDatabase executeQuery:getBackDataSql, data.close.timestamp.timestampValueObj, @(backLimit)];
    
    NSMutableArray *backArray = [NSMutableArray array];
    
    while ([results2 next]) {
        ForexHistoryData *data = [[ForexHistoryData alloc] initWithFMResultSet:results2 currencyPair:_currencyPair timeScale:_timeScale];
        [backArray addObject:data];
    }
    
    [forexDatabase close];
    
    
    
    NSArray *array = [[frontArray arrayByAddingObjectsFromArray:backArray] copy];
    
    return [[ForexDataChunk alloc] initWithForexDataArray:array];
}

-(ForexDataChunk*)selectMaxRowid:(int)rowid limit:(int)limit
{
    int rangeStart = rowid - limit + 1;
    NSRange range = NSMakeRange(rangeStart, limit);
    
    NSMutableArray *array = [NSMutableArray array];
    
    ForexHistoryCacheConfig *selectConfig = [ForexHistoryCacheConfig new];
    selectConfig.currencyPair = _currencyPair;
    selectConfig.timeScale = _timeScaleInt;
    
    if ([selectConfig isEqual:cache.config] && [cache existCacheStartRatesID:range.location Num:range.length]) {
        array = [cache selectCacheStartRatesID:range.location Num:range.length];
    } else {
        unsigned int startID = (unsigned int)range.location;
        unsigned int endID = startID + (unsigned int)range.length -1;
        
        NSString *forexHistoryTableName = [ForexHistoryUtils createTableName:selectConfig.currencyPair.toCodeString timeScale:selectConfig.timeScale];
        
        NSString *sql = [NSString stringWithFormat:@"SELECT rowid,* FROM %@ WHERE rowid >= %d AND rowid <= %d ORDER BY close_minute_close_timestamp DESC", forexHistoryTableName, startID, endID];
        
        [forexDatabase open];
        
        FMResultSet *results = [forexDatabase executeQuery:sql];
        
        while ([results next]) {
            ForexHistoryData *data = [[ForexHistoryData alloc] initWithFMResultSet:results currencyPair:_currencyPair timeScale:_timeScale];
            [array addObject:data];
        }
        
        [forexDatabase close];
        
        [cache override:array config:selectConfig];
    }
    
    return [[ForexDataChunk alloc] initWithForexDataArray:array];
}

-(NSArray*)selectMaxCloseTimestamp:(int)timestamp limit:(int)num
{
    NSMutableArray *array = [NSMutableArray array];
    
    NSString *forexHistoryTableName = [ForexHistoryUtils createTableName:_currencyPair.toCodeString timeScale:_timeScaleInt];
    
    //NSString *sql = [NSString stringWithFormat:@"SELECT rowid,* FROM %@ WHERE open_minute_open_timestamp <= %d ORDER BY open_minute_open_timestamp DESC LIMIT %d", forexHistoryTableName, timestamp, num];
    NSString *sql = [NSString stringWithFormat:@"SELECT rowid,* FROM (SELECT rowid,* FROM %@ WHERE close_minute_close_timestamp <= %d ORDER BY close_minute_close_timestamp DESC LIMIT %d) ORDER BY rowid ASC", forexHistoryTableName, timestamp, num];
    
    [forexDatabase open];
    
    FMResultSet *results = [forexDatabase executeQuery:sql];
    
    while ([results next]) {
        //id<ForexHistoryData> data = [ForexHistoryData createDataFromFMResultSet:results];
        ForexHistoryData *data = [[ForexHistoryData alloc] initWithFMResultSet:results currencyPair:_currencyPair timeScale:_timeScale];
        [array addObject:data];
    }
    
    [forexDatabase close];
    
    return [array copy];
}

-(NSArray*)selectMaxCloseTimestamp:(int)maxTimestamp minOpenTimestamp:(int)minTimestamp
{
    NSMutableArray *array = [NSMutableArray array];
    
    NSString *forexHistoryTableName = [ForexHistoryUtils createTableName:_currencyPair.toCodeString timeScale:_timeScaleInt];
    
    //NSString *sql = [NSString stringWithFormat:@"SELECT rowid,* FROM %@ WHERE open_minute_open_timestamp >= %d and close_minute_close_timestamp <= %d", forexHistoryTableName, minTimestamp, maxTimestamp];
    NSString *sql = [NSString stringWithFormat:@"SELECT rowid,* FROM %@ WHERE open_minute_open_timestamp >= %d and close_minute_close_timestamp <= %d", forexHistoryTableName, minTimestamp, maxTimestamp];
    
    [forexDatabase open];
    
    FMResultSet *results = [forexDatabase executeQuery:sql];
    
    while ([results next]) {
        ForexHistoryData *data = [[ForexHistoryData alloc] initWithFMResultSet:results currencyPair:_currencyPair timeScale:_timeScale];
        [array addObject:data];
    }
    
    [forexDatabase close];
    
    return [array copy];
}

-(ForexHistoryData*)selectOpenTimestamp:(int)timestamp
{
    ForexHistoryData *data;
    
    NSString *sql = [NSString stringWithFormat:@"SELECT rowid,* FROM %@ WHERE open_minute_open_timestamp == %d", _forexHistoryTableName, timestamp];
    
    [forexDatabase open];
    
    FMResultSet *results = [forexDatabase executeQuery:sql];
    
    while ([results next]) {
        data = [[ForexHistoryData alloc] initWithFMResultSet:results currencyPair:_currencyPair timeScale:_timeScale];
    }
    
    [forexDatabase close];
    
    return data;
}

-(ForexHistoryData*)selectRowidLimitCloseTimestamp:(MarketTime*)maxTimestamp
{
    return [[self selectMaxCloseTimestamp:maxTimestamp.timestampValue limit:1] firstObject];
}

-(int)selectCloseTimestampFromRowid:(int)rowid
{
    int openTimestamp = 0;
    
    NSString *sql = [NSString stringWithFormat:@"SELECT rowid,close_minute_close_timestamp FROM %@ WHERE rowid == %d LIMIT 1", _forexHistoryTableName, rowid];
    
    [forexDatabase open];
    
    FMResultSet *results = [forexDatabase executeQuery:sql];
    
    while ([results next]) {
        openTimestamp = [results intForColumn:@"close_minute_close_timestamp"];
    }
    
    [forexDatabase close];
    
    return openTimestamp;
}

-(MarketTime*)minOpenTime
{
    return [self firstRecord].open.timestamp;
}

-(MarketTime*)maxOpenTime
{
    return [self lastRecord].close.timestamp;
}

-(ForexHistoryData*)firstRecord
{
    ForexHistoryData *data;
    
    NSString *sql = [NSString stringWithFormat:@"select rowid,* from %@ limit 1;", _forexHistoryTableName];
    
    [forexDatabase open];
    
    FMResultSet *results = [forexDatabase executeQuery:sql];
    
    while ([results next]) {
        data = [[ForexHistoryData alloc] initWithFMResultSet:results currencyPair:_currencyPair timeScale:_timeScale];
    }
    
    [forexDatabase close];
    
    return data;
}

-(ForexHistoryData*)lastRecord
{
    ForexHistoryData *data;
    
    NSString *sql = [NSString stringWithFormat:@"select rowid,* from %@ order by rowid desc limit 1;", _forexHistoryTableName];
    
    [forexDatabase open];
    
    FMResultSet *results = [forexDatabase executeQuery:sql];
    
    while ([results next]) {
        data = [[ForexHistoryData alloc] initWithFMResultSet:results currencyPair:_currencyPair timeScale:_timeScale];
    }
    
    [forexDatabase close];
    
    return data;
}

@end
