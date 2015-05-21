//
//  ExecutionHistoryFactory.m
//  FX Simulator
//
//  Created  on 2014/10/23.
//  
//

#import "ExecutionHistoryFactory.h"
#import "SaveLoader.h"
#import "SaveData.h"
#import "ExecutionHistory.h"
//#import "EHistoryMock.h"

@implementation ExecutionHistoryFactory

+(ExecutionHistory*)createExecutionHistory
{
    SaveData *saveData = [SaveLoader load];
    
    return [[ExecutionHistory alloc] initWithDataSource:saveData.executionHistoryDataSource];
    //return [EHistoryMock new];
}

@end
