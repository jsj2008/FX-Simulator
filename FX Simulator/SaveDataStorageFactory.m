//
//  SaveDataStorageFactory.m
//  FX Simulator
//
//  Created  on 2014/10/15.
//  
//

#import "SaveDataStorageFactory.h"
#import "SaveDataFileStorage.h"

//#import "SaveDataFileStorageMock.h"

@implementation SaveDataStorageFactory

+(id<SaveDataStorage>)createSaveDataStorage
{
    return [SaveDataFileStorage new];
    //return [SaveDataFileStorageMock new];
}

/*+(id<SaveDataStorage>)createSaveDataTestStorage
{
    return [[SaveDataFileStorage alloc] initWithTestMode];
}*/

@end
