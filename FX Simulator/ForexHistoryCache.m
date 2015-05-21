//
//  CurrencyDatabaseCache.m
//  ForexGame
//
//  Created  on 2014/05/06.
//  
//
#import "ForexHistoryCache.h"
#import "ForexHistoryData.h"


@implementation ForexHistoryCache {
    NSMutableArray *cacheArray;
}

@synthesize cacheSize = _cacheSize;

-(id)initWithCacheSize:(int)size
{
    if (self = [super init]) {
        cacheArray = [NSMutableArray array];
        _cacheSize = size;
    }
    
    return self;
}

-(BOOL)existCacheStartRatesID:(int)startRateID Num:(int)num
{
    int endRateID = startRateID + num - 1;
    
    if (([cacheArray count] == 0) || (((ForexHistoryData*)[cacheArray firstObject]).ratesID > startRateID) || (((ForexHistoryData*)[cacheArray lastObject]).ratesID < endRateID)) {
        return false;
    } else {
        return true;
    }
}

-(void)override:(NSMutableArray *)array config:(ForexHistoryCacheConfig *)config
{
    cacheArray = array;
    _config = config;
}

-(NSMutableArray*)selectCacheStartRatesID:(int)startRateID Num:(int)num
{
    int endRatesID = startRateID + num -1;
    NSMutableArray *selectArray = [NSMutableArray array];
    
    int arraySrart = startRateID - ((ForexHistoryData*)[cacheArray firstObject]).ratesID;
    int arrayEnd = endRatesID - ((ForexHistoryData*)[cacheArray firstObject]).ratesID;
    
    for (int i = arraySrart; i <= arrayEnd; i++) {
        [selectArray addObject:[cacheArray objectAtIndex:i]];
    }
    
    return selectArray;
}

-(int)getIdOfEnd:(int)start numberOf:(int)num
{
    return start + num - 1;
}

@end
