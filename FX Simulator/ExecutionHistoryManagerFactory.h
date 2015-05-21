//
//  ExecutionHistoryManagerFactory.h
//  FX Simulator
//
//  Created  on 2014/12/11.
//  
//

#import <Foundation/Foundation.h>

@class ExecutionHistoryManager;

@interface ExecutionHistoryManagerFactory : NSObject
+(ExecutionHistoryManager*)createExecutionHistoryManager;
@end
