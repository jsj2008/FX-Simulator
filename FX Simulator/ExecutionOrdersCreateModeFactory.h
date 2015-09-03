//
//  ExecutionOrdersCreateModeFactory.h
//  FX Simulator
//
//  Created  on 2014/11/22.
//  
//

#import <Foundation/Foundation.h>

@class ExecutionOrdersCreateMode;
@class Order;

@interface ExecutionOrdersCreateModeFactory : NSObject
- (ExecutionOrdersCreateMode *)createModeFromOrder:(Order *)order;
@end
