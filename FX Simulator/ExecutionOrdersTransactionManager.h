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
//-(BOOL)execute:(NSArray*)orders;
@property (nonatomic, readwrite) BOOL inExecutionOrdersTransaction;
@property (nonatomic, readwrite) FMDatabase *tradeDB;
@end

@interface ExecutionOrdersTransactionManager : NSObject
//+(ExecutionOrdersTransactionManager*)sharedManager;
//-(void)addTransactionTarget:(id<ExecutionOrdersTransactionTarget>)target;
-(id)initWithOpenPositionManager:(OpenPositionManager*)openPositionManager executionHistoryManager:(ExecutionHistoryManager*)executionHistoryManager;
-(BOOL)execute:(NSArray*)orders;
-(void)start;
-(void)commit;
-(void)rollback;
//@property (nonatomic, readonly) BOOL isStart;
//@property (nonatomic, readonly) FMDatabase *tradeDatabase;
@end
