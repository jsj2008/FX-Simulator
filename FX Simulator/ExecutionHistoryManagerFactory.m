//
//  ExecutionHistoryManagerFactory.m
//  FX Simulator
//
//  Created  on 2014/12/11.
//  
//

#import "ExecutionHistoryManagerFactory.h"
#import "SaveLoader.h"
#import "SaveData.h"
#import "ExecutionHistoryManager.h"

@implementation ExecutionHistoryManagerFactory

+(ExecutionHistoryManager*)createExecutionHistoryManager
{
    SaveData *saveData = [SaveLoader load];
    
    return [[ExecutionHistoryManager alloc] initWithDataSource:saveData.executionHistoryDataSource];
}

@end
