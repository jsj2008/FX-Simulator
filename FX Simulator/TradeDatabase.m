//
//  TradeDatabase.m
//  FX Simulator
//
//  Created  on 2014/07/17.
//  
//

#import "TradeDatabase.h"

#import "TradeDatabase+Protected.h"
#import "FMDatabase.h"
#import "SaveData.h"

static FMDatabase *db;
static NSUInteger FXSSaveSlot;
static BOOL inTransaction;
static NSString* const dbFileName = @"trade_db.sqlite3";
static NSString* const testDbFileName = @"TradeTestDb.sqlite3";

@implementation TradeDatabase

+ (void)loadSaveData:(SaveData *)saveData
{
    FXSSaveSlot = saveData.slotNumber;
}

#pragma mark - execute

+ (void)execute:(void (^)(FMDatabase *, NSUInteger))block
{
    if (FXSSaveSlot == 0 || block == nil) {
        return;
    }
    
    FMDatabase *db = [self db];
    
    if (!inTransaction) {
        [db open];
    }
    
    block(db, FXSSaveSlot);
    
    if (!inTransaction) {
        [db close];
    }
}

+ (void)transaction:(void (^)())block
{
    if (!block) {
        return;
    }
    
    inTransaction = YES;
    
    FMDatabase *db = [self db];
    
    [db open];
    [db beginTransaction];
    
    @try {
        block();
        [db commit];
    }
    @catch (NSException *exception) {
        [db rollback];
        @throw exception;
    }
    @finally {
        [db close];
        inTransaction = NO;
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
        BOOL result = [fm copyItemAtPath:bundleDbPath toPath:dbPath error:&error];
        
        if (result) {
            DLog(@"ファイルのコピーに成功：%@ → %@", bundleDbPath, dbPath);
        } else {
            DLog(@"ファイルのコピーに失敗：%@", error.description);
        }
    }
    
    return [FMDatabase databaseWithPath:dbPath];
}

@end
