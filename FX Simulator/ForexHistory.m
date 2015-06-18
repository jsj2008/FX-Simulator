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
    int _timeScale;
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
        _timeScale = timeScale.minute;
        _forexHistoryTableName = [ForexHistoryUtils createTableName:_currencyPair.toCodeString timeScale:_timeScale];
    }
    
    return self;
}

-(NSArray*)selectMaxRowid:(int)rowid limit:(int)limit
{
    int rangeStart = rowid - limit + 1;
    NSRange range = NSMakeRange(rangeStart, limit);
    
    NSMutableArray *array = [NSMutableArray array];
    
    ForexHistoryCacheConfig *selectConfig = [ForexHistoryCacheConfig new];
    selectConfig.currencyPair = _currencyPair;
    selectConfig.timeScale = _timeScale;
    
    if ([selectConfig isEqual:cache.config] && [cache existCacheStartRatesID:range.location Num:range.length]) {
        array = [cache selectCacheStartRatesID:range.location Num:range.length];
    } else {
        unsigned int startID = (unsigned int)range.location;
        unsigned int endID = startID + (unsigned int)range.length -1;
        
        NSString *forexHistoryTableName = [ForexHistoryUtils createTableName:selectConfig.currencyPair.toCodeString timeScale:selectConfig.timeScale];
        
        NSString *sql = [NSString stringWithFormat:@"SELECT rowid,* FROM %@ WHERE rowid >= %d AND rowid <= %d", forexHistoryTableName, startID, endID];
        
        [forexDatabase open];
        
        FMResultSet *results = [forexDatabase executeQuery:sql];
        
        while ([results next]) {
            ForexHistoryData *data = [[ForexHistoryData alloc] initWithFMResultSet:results currencyPair:_currencyPair];
            [array addObject:data];
        }
        
        [forexDatabase close];
        
        [cache override:array config:selectConfig];
    }
    
    
    return [array copy];
}

-(NSArray*)selectMaxCloseTimestamp:(int)timestamp limit:(int)num
{
    NSMutableArray *array = [NSMutableArray array];
    
    NSString *forexHistoryTableName = [ForexHistoryUtils createTableName:_currencyPair.toCodeString timeScale:_timeScale];
    
    //NSString *sql = [NSString stringWithFormat:@"SELECT rowid,* FROM %@ WHERE open_minute_open_timestamp <= %d ORDER BY open_minute_open_timestamp DESC LIMIT %d", forexHistoryTableName, timestamp, num];
    NSString *sql = [NSString stringWithFormat:@"SELECT rowid,* FROM (SELECT rowid,* FROM %@ WHERE close_minute_close_timestamp <= %d ORDER BY close_minute_close_timestamp DESC LIMIT %d) ORDER BY rowid ASC", forexHistoryTableName, timestamp, num];
    
    [forexDatabase open];
    
    FMResultSet *results = [forexDatabase executeQuery:sql];
    
    while ([results next]) {
        //id<ForexHistoryData> data = [ForexHistoryData createDataFromFMResultSet:results];
        ForexHistoryData *data = [[ForexHistoryData alloc] initWithFMResultSet:results currencyPair:_currencyPair];
        [array addObject:data];
    }
    
    [forexDatabase close];
    
    return [array copy];
}

-(NSArray*)selectMaxCloseTimestamp:(int)maxTimestamp minOpenTimestamp:(int)minTimestamp
{
    NSMutableArray *array = [NSMutableArray array];
    
    NSString *forexHistoryTableName = [ForexHistoryUtils createTableName:_currencyPair.toCodeString timeScale:_timeScale];
    
    //NSString *sql = [NSString stringWithFormat:@"SELECT rowid,* FROM %@ WHERE open_minute_open_timestamp >= %d and close_minute_close_timestamp <= %d", forexHistoryTableName, minTimestamp, maxTimestamp];
    NSString *sql = [NSString stringWithFormat:@"SELECT rowid,* FROM %@ WHERE open_minute_open_timestamp >= %d and close_minute_close_timestamp <= %d", forexHistoryTableName, minTimestamp, maxTimestamp];
    
    [forexDatabase open];
    
    FMResultSet *results = [forexDatabase executeQuery:sql];
    
    while ([results next]) {
        ForexHistoryData *data = [[ForexHistoryData alloc] initWithFMResultSet:results currencyPair:_currencyPair];
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
        data = [[ForexHistoryData alloc] initWithFMResultSet:results currencyPair:_currencyPair];
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
        data = [[ForexHistoryData alloc] initWithFMResultSet:results currencyPair:_currencyPair];
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
        data = [[ForexHistoryData alloc] initWithFMResultSet:results currencyPair:_currencyPair];
    }
    
    [forexDatabase close];
    
    return data;
}

@end
