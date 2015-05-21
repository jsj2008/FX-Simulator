//
//  ExecutionHistoryFactory.h
//  FX Simulator
//
//  Created  on 2014/10/23.
//  
//

#import <Foundation/Foundation.h>

@class ExecutionHistory;

@interface ExecutionHistoryFactory : NSObject
+(ExecutionHistory*)createExecutionHistory;
@end
