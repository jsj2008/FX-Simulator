//
//  TradeDatabase.h
//  FX Simulator
//
//  Created  on 2014/07/17.
//  
//

#import <Foundation/Foundation.h>


@class FMDatabase;
@class SaveData;

@interface TradeDatabase : NSObject

+ (void)loadSaveData:(SaveData *)saveData;

+ (void)transaction:(void (^)())block;

@end
