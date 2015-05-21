//
//  TradeDatabase.h
//  FX Simulator
//
//  Created  on 2014/07/17.
//  
//

//#import "DatabaseProtocol.h"
//#import "Database.h"

#import <Foundation/Foundation.h>


@class FMDatabase;

@interface TradeDatabase : NSObject
+(FMDatabase*)dbConnect;
//-(FMDatabase*)dbConnect;
@end
