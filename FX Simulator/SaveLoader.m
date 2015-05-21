//
//  SaveLoader.m
//  FX Simulator
//
//  Created  on 2014/10/19.
//  
//

#import "SaveLoader.h"

#import "SaveData.h"

@implementation SaveLoader

static SaveData *sharedSaveData;

+(SaveData*)load
{
    int slotNumber = 1;
    
    @synchronized(self) {
        if (sharedSaveData == nil) {
            sharedSaveData = [[SaveData alloc] initWithDefaultDataAndSlotNumber:slotNumber];
        }
    }
    
    return sharedSaveData;
}

+(void)setSharedSaveData:(SaveData *)saveData
{
    @synchronized(self) {
        sharedSaveData = saveData;
    }
}

@end
