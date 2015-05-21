//
//  NewExecutionOrder.h
//  FX Simulator
//
//  Created  on 2014/11/22.
//  
//

#import "ExecutionOrder.h"

@class ExecutionOrderMaterial;
@class FMResultSet;

@interface NewExecutionOrder : ExecutionOrder
-(id)initWithExecutionOrderMaterial:(ExecutionOrderMaterial*)material;
//-(id)initWithFMResultSet:(FMResultSet*)rs;
@end
