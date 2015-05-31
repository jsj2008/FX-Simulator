//
//  SaveDataFileStorage.m
//  FX Simulator
//
//  Created  on 2014/10/08.
//  
//

#import "SaveDataFileStorage.h"

#import "FMDatabase.h"
#import "SaveData.h"
#import "Currency.h"
#import "CurrencyPair.h"
#import "FXSTest.h"
#import "Spread.h"
#import "TradeDbDataSource.h"

static NSString* const saveDataFileName = @"SaveData.plist";
static NSString* const saveDataTestFileName = @"SaveDataTest.plist";

@implementation SaveDataFileStorage {
    NSString *saveDataFilePath;
}

-(id)init
{
    if (self = [super init]) {
        if ([FXSTest inTest]) {
            saveDataFilePath = [self getSaveDataFilePath:saveDataTestFileName];
        } else {
            saveDataFilePath = [self getSaveDataFilePath:saveDataFileName];
        }
        [self setSaveDataFile:saveDataFilePath];
    }
    
    return self;
}

/*-(instancetype)initWithTestMode
{
    if (self = [super init]) {
        NSString *path = [self getSaveDataFilePath:saveDataTestFileName];
        [self setSaveDataFile:path];
    }
    
    return self;
}*/

-(NSString*)getSaveDataFilePath:(NSString *)fileName
{
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    return path;
}

-(void)setSaveDataFile:(NSString*)path
{
    BOOL ret;
    NSFileManager *fm = [NSFileManager defaultManager];
    ret = [fm fileExistsAtPath:path];
    
    if(!ret){
        [fm createFileAtPath:path contents:nil attributes:nil];
    }
}

-(BOOL)existSaveDataSlotNumber:(int)num
{
    NSMutableDictionary *saveDataFileDic = [NSMutableDictionary dictionaryWithContentsOfFile:saveDataFilePath];
    NSDictionary *saveDataDic = [saveDataFileDic objectForKey:[NSString stringWithFormat:@"%d", num]];
    
    if (saveDataDic != nil) {
        return true;
    } else {
        return false;
    }

}

-(BOOL)save:(SaveData *)saveData
{
    if (![self validateSaveData:saveData]) {
        return NO;
    }
    
    NSMutableDictionary *saveDataFileDic =  [NSMutableDictionary dictionaryWithContentsOfFile:saveDataFilePath];
    
    if (saveDataFileDic == nil) {
        saveDataFileDic = [NSMutableDictionary dictionary];
    }
    
    NSDictionary *saveDataDic = saveData.saveDataDictionary;
    
    [saveDataFileDic setObject:saveDataDic forKey:[NSString stringWithFormat:@"%d", saveData.slotNumber]];
    
    return [saveDataFileDic writeToFile:saveDataFilePath atomically:YES];
}

-(BOOL)validateSaveData:(SaveData *)saveData
{
    if (saveData == nil) {
        return NO;
    }
    
    return YES;
}

-(BOOL)newSave:(SaveData *)saveData
{
    if ([self existSaveDataSlotNumber:saveData.slotNumber]) {
        [self deleteFromSlotNumber:@(saveData.slotNumber)];
    }
    
    return [self save:saveData];
}

-(BOOL)updateSave:(SaveData*)saveData
{
    if (![self existSaveDataSlotNumber:saveData.slotNumber]) {
        return NO;
    }
    
    return [self save:saveData];
    
    /*NSDictionary *saveDataDic = @{@"SaveSlot":[NSNumber numberWithInt:saveData.slotNumber],
                                  @"CurrencyPair":[saveData.currencyPair toArray],
                                  @"TimeScale":[NSNumber numberWithInt:saveData.timeScale],
                                  @"Spread":saveData.spread.spreadValueObj,
                                  @"AccountCurrency":saveData.accountCurrency.toString,
                                  @"StartAmount":[NSNumber numberWithUnsignedLongLong:saveData.startAmount],
                                  @"PositionSizeOfLot":[NSNumber numberWithInt:saveData.positionSizeOfLot],
                                  @"Lot":[NSNumber numberWithUnsignedLongLong:saveData.lot],
                                  @"LastLoadedCloseTimestamp":[NSNumber numberWithInt:saveData.lastLoadedCloseTimestamp],
                                  @"IsMarketPaused":[NSNumber numberWithBool:saveData.isMarketPaused],
                                  @"SubChartSelectedTimeScale":[NSNumber numberWithInt:saveData.subChartSelectedTimeScale],
                                  @"OrderHistoryTableName":saveData.orderHistoryTableName,
                                  @"ExecutionHistoryTableName":saveData.executionHistoryTableName,
                                  @"OpenPositionTableName":saveData.openPositionTableName};*/
}

-(SaveData*)loadSlotNumber:(int)num
{
    NSMutableDictionary *saveDataFileDic = [NSMutableDictionary dictionaryWithContentsOfFile:saveDataFilePath];
    NSDictionary *saveDataDic = [saveDataFileDic objectForKey:[NSString stringWithFormat:@"%d", num]];
    
    SaveData *saveData = [[SaveData alloc] initWithSaveDataDictionary:saveDataDic];
    
    return saveData;
}

-(BOOL)deleteFromSlotNumber:(NSNumber *)number
{
    if (number == nil) {
        return NO;
    }
    
    NSMutableDictionary *saveDataFileDic = [NSMutableDictionary dictionaryWithContentsOfFile:saveDataFilePath];
    
    NSDictionary *saveDataDic = [saveDataFileDic objectForKey:number.stringValue];
    
    if (saveDataDic == nil) {
        return NO;
    }
    
    SaveData *saveData = [[SaveData alloc] initWithSaveDataDictionary:saveDataDic];
    
    [self deleteTableFromDataSource:saveData.orderHistoryDataSource];
    [self deleteTableFromDataSource:saveData.executionHistoryDataSource];
    [self deleteTableFromDataSource:saveData.openPositionDataSource];
    
    
    [saveDataFileDic removeObjectForKey:number.stringValue];
    [saveDataFileDic writeToFile:saveDataFilePath atomically:YES];
    
    return YES;
}

-(void)deleteAll
{
    NSMutableDictionary *saveDataFileDic = [NSMutableDictionary dictionaryWithContentsOfFile:saveDataFilePath];
    
    for (NSString *key in saveDataFileDic.allKeys) {
        [self deleteFromSlotNumber:@(key.intValue)];
    }
    
    [saveDataFileDic removeAllObjects];
    [saveDataFileDic writeToFile:saveDataFilePath atomically:YES];
}

-(void)deleteTableFromDataSource:(TradeDbDataSource*)dataSource
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@;", dataSource.tableName];
    FMDatabase *tradeDb = dataSource.connection;
    
    [tradeDb open];
    [tradeDb executeUpdate:sql];
    [tradeDb close];
}

@end
