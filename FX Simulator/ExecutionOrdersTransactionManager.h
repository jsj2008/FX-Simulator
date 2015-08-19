//
//  ExecutionOrdersTransactionManager.h
//  FX Simulator
//
//  Created  on 2014/11/25.
//  
//

#import <Foundation/Foundation.h>

@class OpenPosition;
@class ExecutionHistory;

@protocol ExecutionOrdersTransactionTarget <NSObject>
@property (nonatomic, readwrite) BOOL inExecutionOrdersTransaction;
@end

@interface ExecutionOrdersTransactionManager : NSObject
-(id)initWithOpenPosition:(OpenPosition *)openPosition executionHistory:(ExecutionHistory *)executionHistory;
-(BOOL)execute:(NSArray*)orders;
@end
