//
//  OrderForExecution.h
//  FX Simulator
//
//  Created  on 2014/11/22.
//  
//

#import "ExecutionOrder.h"

@class Order;
@class PositionType;

@interface ExecutionOrderMaterial : ExecutionOrder
-(id)initWithOrder:(Order*)order usersOrderNumber:(int)number;
@end
