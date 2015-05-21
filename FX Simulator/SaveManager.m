//
//  SaveManager.m
//  FX Simulator
//
//  Created  on 2015/01/17.
//  
//

#import "SaveManager.h"

#import "FMDatabase.h"
#import "TradeDatabase.h"
#import "SaveData.h"
#import "SaveDataFileStorage.h"
#import "SaveDataStorageFactory.h"
#import "TradeDbDataSource.h"

@implementation SaveManager

+(void)deleteSaveDataForSlotNumber:(NSNumber *)number
{
    id<SaveDataStorage> saveDataStorage = [SaveDataStorageFactory createSaveDataStorage];
    
    if (![saveDataStorage existSaveDataSlotNumber:number.intValue]) {
        return;
    }
    
    SaveData *saveData = [saveDataStorage loadSlotNumber:[number intValue]];
    
    // Delete Table
    
    NSArray *dropTableTargets = @[saveData.orderHistoryDataSource.tableName, saveData.executionHistoryDataSource.tableName, saveData.openPositionDataSource.tableName];
    
    FMDatabase *db = [TradeDatabase dbConnect];
    
    for (NSString *tableName in dropTableTargets) {
        NSString *sql = [NSString stringWithFormat:@"drop table %@;", tableName];
        [db executeUpdate:sql];
    }
    
    // Delete SaveData
    
    [saveDataStorage deleteSlotNumber:number];
}

@end
