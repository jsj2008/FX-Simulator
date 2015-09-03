//
//  TradeDatabase+Protected.h
//  FXSimulator
//
//  Created by yuu on 2015/08/30.
//
//

#import "TradeDatabase.h"

@class FMDatabase;

@interface TradeDatabase ()

+ (void)execute:(void (^)(FMDatabase *db, NSUInteger saveSlot))block;

@end
