//
//  ForexDatabase.h
//  FX Simulator
//
//  Created  on 2014/07/18.
//  
//

#import <Foundation/Foundation.h>

@class FMDatabase;

@interface ForexDatabase : NSObject
+(FMDatabase*)dbConnect;
@end
