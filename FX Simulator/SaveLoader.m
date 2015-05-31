//
//  SaveLoader.m
//  FX Simulator
//
//  Created  on 2014/10/19.
//  
//

#import "SaveLoader.h"

#import "SaveData.h"
#import "SaveDataFileStorage.h"
#import "SaveDataStorageFactory.h"

@implementation SaveLoader

static SaveData *sharedSaveData;

+(SaveData*)load
{
    int slotNumber = 1;
    
    @synchronized(self) {
        if (sharedSaveData == nil) {
            id<SaveDataStorage> storage = [SaveDataStorageFactory createSaveDataStorage];
            
            sharedSaveData = [storage loadSlotNumber:slotNumber];
            //sharedSaveData = [[SaveData alloc] initWithDefaultDataAndSlotNumber:slotNumber];
            
            if (sharedSaveData == nil) {
                SaveData *defaultSaveData = [[SaveData alloc] initWithDefaultDataAndSlotNumber:slotNumber];
                [storage newSave:defaultSaveData];
                sharedSaveData = [storage loadSlotNumber:slotNumber];
            }
        }
    }
    
    return sharedSaveData;
}

+(void)reloadSaveData
{
    @synchronized(self) {
        if (sharedSaveData != nil) {
            sharedSaveData = nil;
        }
    }
}

/*+(void)setSharedSaveData:(SaveData *)saveData
{
    @synchronized(self) {
        sharedSaveData = saveData;
    }
}*/

@end
