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

- (instancetype)initWithFMResultSet:(FMResultSet *)rs
{
    if (self = [super init]) {
        _saveSlot = [rs intForColumn:@"save_slot"];
        _recordId = [rs intForColumn:@"id"];
        _executionOrderId = [rs intForColumn:@"execution_order_id"];
        _positionSize = [[PositionSize alloc] initWithSizeValue:[rs intForColumn:@"position_size"]];
    }
    
    return self;
}

@end
