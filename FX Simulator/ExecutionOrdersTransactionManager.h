//
//  ExecutionOrdersTransactionManager.h
//  FX Simulator
//
//  Created  on 2014/11/25.
//  
//

#import <Foundation/Foundation.h>

@class FMDatabase;
@class OpenPositionManager;
@class ExecutionHistoryManager;

@protocol ExecutionOrdersTransactionTarget <NSObject>
@property (nonatomic, readwrite) BOOL inExecutionOrdersTransaction;
@end

@interface ExecutionOrdersTransactionManager : NSObject
-(id)initWithOpenPositionManager:(OpenPositionManager*)openPositionManager executionHistoryManager:(ExecutionHistoryManager*)executionHistoryManager;
-(BOOL)execute:(NSArray*)orders;
-(void)start;
-(void)commit;
-(void)rollback;
@end
