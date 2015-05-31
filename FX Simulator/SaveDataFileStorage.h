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
/**
 既存のトレード履歴データベース(オープンポジション、約定履歴)があった場合、それを削除して、新たなセーブデータを作成する。
*/
-(BOOL)newSave:(SaveData*)saveData;
-(BOOL)updateSave:(SaveData*)saveData;
-(SaveData*)loadSlotNumber:(int)number;
-(BOOL)deleteFromSlotNumber:(NSNumber*)number;
-(void)deleteAll;
@end

@interface SaveDataFileStorage : NSObject <SaveDataStorage>
//-(instancetype)initWithTestMode;
-(BOOL)existSaveDataSlotNumber:(int)num;
-(BOOL)newSave:(SaveData*)saveData;
-(BOOL)updateSave:(SaveData*)saveData;
-(SaveData*)loadSlotNumber:(int)number;
-(BOOL)deleteFromSlotNumber:(NSNumber*)number;
-(void)deleteAll;
@end
