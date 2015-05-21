//
//  CurrencyDatabaseCache.h
//  ForexGame
//
//  Created  on 2014/05/06.
//  
//

#import <Foundation/Foundation.h>


@class ForexHistoryCacheConfig;

@interface ForexHistoryCache : NSObject
-(id)initWithCacheSize:(int)size;
-(BOOL)existCacheStartRatesID:(int)start Num:(int)num;
-(void)override:(NSMutableArray*)array config:(ForexHistoryCacheConfig*)config;
-(NSMutableArray*)selectCacheStartRatesID:(int)start Num:(int)num;
@property (readonly) int cacheSize;
@property (nonatomic) ForexHistoryCacheConfig *config;
@end
