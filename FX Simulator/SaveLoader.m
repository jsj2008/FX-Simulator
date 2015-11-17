//
//  SaveLoader.m
//  FX Simulator
//
//  Created  on 2014/10/19.
//  
//

#import "SaveLoader.h"

#import "SaveData.h"

static NSString* const FXSLastLoadedSaveDataSlotNumberKey = @"LastLoadedSaveDataSlotNumber";

@implementation SaveLoader

+ (SaveData *)loadDefaultSaveData
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSUInteger saveSlot = [userDefaults integerForKey:FXSLastLoadedSaveDataSlotNumberKey];
    
    SaveData *saveData;
    
    if (saveSlot == 0) {
        saveData = [SaveData createDefaultNewSaveData];
        [saveData saveWithCompletion:nil error:nil];
    } else {
        saveData = [SaveData loadFromSlotNumber:saveSlot];
    }
    
    return saveData;
}

+ (void)setLastLoadedSaveDataSlotNumber:(NSUInteger)slotNumber
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setInteger:slotNumber forKey:FXSLastLoadedSaveDataSlotNumberKey];
}

@end
