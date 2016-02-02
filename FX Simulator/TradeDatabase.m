//
//  TradeDatabase.m
//  FX Simulator
//
//  Created  on 2014/07/17.
//  
//

#import "TradeDatabase.h"

#import "FMDatabase.h"
#import "SaveData.h"
#import "TradeDatabase+Protected.h"

static FMDatabase *db;
static BOOL inTransaction;
static NSString* const dbFileName = @"trade_db.sqlite3";
static NSString* const testDbFileName = @"TradeTestDb.sqlite3";

@implementation TradeDatabase

#pragma mark - execute

+ (void)execute:(void (^)(FMDatabase *))block
{
    if (!block) {
        return;
    }
    
    FMDatabase *db = [self db];
    
    if (!inTransaction) {
        [db open];
    }
    
    block(db);
    
    if (!inTransaction) {
        [db close];
    }
}

+ (void)transaction:(void (^)())block completion:(void (^)(BOOL))completion
{
    if (!block) {
        return;
    }
    
    inTransaction = YES;
    
    BOOL isRollbacked = NO;
    
    FMDatabase *db = [self db];
    
    [db open];
    [db beginTransaction];
    
    @try {
        block();
        [db commit];
    }
    @catch (NSException *exception) {
        [db rollback];
        isRollbacked = YES;
    }
    @finally {
        
        [db close];
        inTransaction = NO;
        
        if (completion) {
            completion(isRollbacked);
        }
        
    }
    
}

#pragma mark - database

+ (FMDatabase *)db
{
    if (!db) {
        db = [self dbConnect];
    }
    
    return db;
}

+ (FMDatabase *)dbConnect
{
    return [self connectOfDbFileName:dbFileName];
}

+ (FMDatabase *)testDbConnect
{
    return [self connectOfDbFileName:testDbFileName];
}

+ (FMDatabase *)connectOfDbFileName:(NSString *)fileName
{
    NSString *dbPath;
    
    BOOL ret;
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    dbPath = [documentsDirectory stringByAppendingPathComponent:fileName];
    ret = [fm fileExistsAtPath:dbPath];
    
    NSError *error;
    
    if(!ret){
        NSString *bundleDbPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName];
        [fm copyItemAtPath:bundleDbPath toPath:dbPath error:&error];
    }
    
    return [FMDatabase databaseWithPath:dbPath];
}

@end
