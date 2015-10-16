//
//  ForexDatabase.h
//  FX Simulator
//
//  Created  on 2014/07/18.
//  
//

#import <Foundation/Foundation.h>

@class FMDatabase;
@class FMDatabaseQueue;

@interface ForexDatabase : NSObject
+ (FMDatabase *)dbConnect;
+ (FMDatabaseQueue *)dbQueueConnect;
@end
