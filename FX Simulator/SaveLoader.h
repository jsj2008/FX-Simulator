//
//  SaveLoader.h
//  FX Simulator
//
//  Created  on 2014/10/19.
//  
//

#import <Foundation/Foundation.h>

@class SaveData;

@interface SaveLoader : NSObject
+(SaveData*)load;
+(void)reloadSaveData;
@end
