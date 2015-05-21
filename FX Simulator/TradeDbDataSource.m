//
//  TradeDbDataSource.m
//  FX Simulator
//
//  Created  on 2014/12/09.
//  
//

#import "TradeDbDataSource.h"

#import "TradeDatabase.h"

@implementation TradeDbDataSource

-(id)initWithTableName:(NSString *)tableName SaveSlotNumber:(NSNumber *)num
{
    if (self = [super init]) {
        _saveSlotNumber = num;
        _tableName = tableName;
        _connection = [TradeDatabase dbConnect];
    }
    
    return self;
}

@end
