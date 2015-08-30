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
        _openPositionId = [rs intForColumn:@"id"];
        _executionHistoryId = [rs intForColumn:@"execution_history_id"];
        _positionSize = [[PositionSize alloc] initWithSizeValue:[rs intForColumn:@"open_position_size"]];
    }
    
    return self;
}

@end
