//
//  SaveDataFileStorage.h
//  FX Simulator
//
//  Created  on 2014/10/08.
//  
//

#import <Foundation/Foundation.h>

@class SaveData;

@protocol SaveDataStorage <NSObject>
-(BOOL)existSaveDataSlotNumber:(int)num;
-(BOOL)save:(SaveData*)saveData;
-(SaveData*)loadSlotNumber:(int)number;
-(void)deleteFromSlotNumber:(NSNumber*)number;
@end

@interface SaveDataFileStorage : NSObject <SaveDataStorage>
-(BOOL)existSaveDataSlotNumber:(int)num;
-(BOOL)save:(SaveData*)saveData;
-(SaveData*)loadSlotNumber:(int)number;
-(void)deleteFromSlotNumber:(NSNumber*)number;
@end
