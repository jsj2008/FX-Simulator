//
//  SaveDataStorageFactory.h
//  FX Simulator
//
//  Created  on 2014/10/15.
//  
//

#import <Foundation/Foundation.h>

@protocol SaveDataStorage;

@interface SaveDataStorageFactory : NSObject
+(id<SaveDataStorage>)createSaveDataStorage;
@end
