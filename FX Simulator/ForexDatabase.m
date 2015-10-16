//
//  ForexDatabase.m
//  FX Simulator
//
//  Created  on 2014/07/18.
//  
//

#import "ForexDatabase.h"

#import "FMDatabase.h"
#import "FMDatabaseQueue.h"

static NSString* const dbFileName = @"forex_time_scale.sqlite";

@implementation ForexDatabase

+ (FMDatabase *)dbConnect
{
    return [FMDatabase databaseWithPath:[self dbPath]];
}

+ (FMDatabaseQueue *)dbQueueConnect
{
    return [FMDatabaseQueue databaseQueueWithPath:[self dbPath]];
}

+ (NSString *)dbPath
{
    return [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:dbFileName];
}

@end
