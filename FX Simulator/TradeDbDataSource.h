//
//  TradeDbDataSource.h
//  FX Simulator
//
//  Created  on 2014/12/09.
//  
//

#import <Foundation/Foundation.h>

@class FMDatabase;

@interface TradeDbDataSource : NSObject
-(id)initWithTableName:(NSString*)tableName SaveSlotNumber:(NSNumber*)num;
@property (nonatomic, readonly) NSNumber *saveSlotNumber;
@property (nonatomic, readonly) NSString *tableName;
@property (nonatomic, readonly) FMDatabase *connection;
@end
