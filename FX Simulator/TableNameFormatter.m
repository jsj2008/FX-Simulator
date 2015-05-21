//
//  TableNameFormatter.m
//  FX Simulator
//
//  Created  on 2014/10/21.
//  
//

#import "TableNameFormatter.h"

static NSString* const kOrderHistoryTableName = @"order_history";
static NSString* const kExecutionHistoryTableName = @"execution_history";
static NSString* const kOpenPositionTableName = @"open_position";

@implementation TableNameFormatter

+(NSString*)orderHistoryTableNameForSaveSlot:(int)num
{
    return [NSString stringWithFormat:@"save_%d_%@", num, kOrderHistoryTableName];
}

+(NSString*)executionHistoryTableNameForSaveSlot:(int)num
{
    return [NSString stringWithFormat:@"save_%d_%@", num, kExecutionHistoryTableName];
}

+(NSString*)openPositionTableNameForSaveSlot:(int)num
{
    return [NSString stringWithFormat:@"save_%d_%@", num, kOpenPositionTableName];

}

@end
