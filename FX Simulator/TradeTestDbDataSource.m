//
//  TradeTestDbDataSource.m
//  FX Simulator
//
//  Created  on 2015/05/27.
//  
//

#import "TradeTestDbDataSource.h"

#import "TradeDatabase.h"

@implementation TradeTestDbDataSource

@synthesize connection = _connection;

-(instancetype)initWithTableName:(NSString *)tableName SaveSlotNumber:(NSNumber *)num
{
    if ([super initWithTableName:tableName SaveSlotNumber:num]) {
        _connection = [TradeDatabase testDbConnect];
    }
    
    return self;
}

@end
