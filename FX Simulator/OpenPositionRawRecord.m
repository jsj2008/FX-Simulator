//
//  OpenPositionRawRecord.m
//  FX Simulator
//
//  Created  on 2014/12/10.
//  
//

#import "OpenPositionRawRecord.h"

#import "FMResultSet.h"
#import "PositionSize.h"

@implementation OpenPositionRawRecord

-(id)initWithFMResultSet:(FMResultSet *)rs
{
    if (self = [super init]) {
        _recordID = [NSNumber numberWithInt:[rs intForColumn:@"id"]];
        //_usersOrderNumber = [NSNumber numberWithInt:[rs intForColumn:@"users_order_number"]];
        _executionOrderID = [NSNumber numberWithInt:[rs intForColumn:@"execution_order_id"]];
        _positionSize = [[PositionSize alloc] initWithSizeValue:[rs intForColumn:@"position_size"]];
    }
    
    return self;
}

@end
