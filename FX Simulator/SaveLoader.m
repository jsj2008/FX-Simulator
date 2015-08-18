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
static NSUInteger FXSDefaultSlotNumber = 1;

+ (SaveData*)load
{
    @synchronized(self) {
        if (sharedSaveData == nil) {
            
            sharedSaveData = [SaveData loadFromSlotNumber:FXSDefaultSlotNumber];
            
            if (sharedSaveData == nil) {
                sharedSaveData = [SaveData createDefaultSaveDataFromSlotNumber:FXSDefaultSlotNumber];
            }
        }
    }
    
    return sharedSaveData;
}

+ (void)reloadSaveData
{
    @synchronized(self) {
        if (sharedSaveData != nil) {
            sharedSaveData = nil;
        }
    }
}

@end
