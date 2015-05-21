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
#import "Spread.h"
#import "TradeDbDataSource.h"

static NSString* const saveDataFileName = @"SaveData.plist";

@implementation SaveDataFileStorage {
    NSString *saveDataFilePath;
}

-(id)init
{
    if (self = [super init]) {
        [self setSaveDataFilePath];
        [self setSaveDataFile];
    }
    
    return self;
}

-(void)setSaveDataFilePath
{
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    saveDataFilePath = [documentsDirectory stringByAppendingPathComponent:saveDataFileName];
}

-(void)setSaveDataFile
{
    BOOL ret;
    NSFileManager *fm = [NSFileManager defaultManager];
    ret = [fm fileExistsAtPath:saveDataFilePath];
    
    if(!ret){
        [fm createFileAtPath:saveDataFilePath contents:nil attributes:nil];
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

-(BOOL)save:(SaveData*)saveData
{
    NSMutableDictionary *saveDataFileDic =  [NSMutableDictionary dictionaryWithContentsOfFile:saveDataFilePath];
    
    if (saveDataFileDic == nil) {
        saveDataFileDic = [NSMutableDictionary dictionary];
    }
    
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
    
    NSDictionary *saveDataDic = saveData.saveDataDictionary;
    
    [saveDataFileDic setObject:saveDataDic forKey:[NSString stringWithFormat:@"%d", saveData.slotNumber]];
    
    return [saveDataFileDic writeToFile:saveDataFilePath atomically:YES];
}

-(SaveData*)loadSlotNumber:(int)num
{
    NSMutableDictionary *saveDataFileDic = [NSMutableDictionary dictionaryWithContentsOfFile:saveDataFilePath];
    NSDictionary *saveDataDic = [saveDataFileDic objectForKey:[NSString stringWithFormat:@"%d", num]];
    
    SaveData *saveData = [[SaveData alloc] initWithSaveDataDictionary:saveDataDic];
    
    return saveData;
}

-(void)deleteFromSlotNumber:(NSNumber *)number
{
    NSMutableDictionary *saveDataFileDic = [NSMutableDictionary dictionaryWithContentsOfFile:saveDataFilePath];
    
    NSDictionary *saveDataDic = [saveDataFileDic objectForKey:number.stringValue];
    SaveData *saveData = [[SaveData alloc] initWithSaveDataDictionary:saveDataDic];
    
    [self deleteTableFromDataSource:saveData.orderHistoryDataSource];
    [self deleteTableFromDataSource:saveData.executionHistoryDataSource];
    [self deleteTableFromDataSource:saveData.openPositionDataSource];
    
    
    [saveDataFileDic removeObjectForKey:number.stringValue];
    [saveDataFileDic writeToFile:saveDataFilePath atomically:YES];
}

-(void)deleteTableFromDataSource:(TradeDbDataSource*)dataSource
{
#warning テーブルの削除ではなく、データの削除にする。
    FMDatabase *tradeDb = dataSource.connection;
    
    [tradeDb open];
    [tradeDb executeUpdate:@"DROP TABLE IF EXISTS %@;", dataSource.tableName];
    [tradeDb close];
}

@end
