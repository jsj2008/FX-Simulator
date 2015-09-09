//
//  ExecutionOrdersCreateModeFactory.h
//  FX Simulator
//
//  Created  on 2014/11/22.
//  
//

#import <Foundation/Foundation.h>

@class Order;
@class OrdersCreateMode;

@interface OrdersCreateModeFactory : NSObject
+ (OrdersCreateMode *)createModeFromOrder:(Order *)order;
@end
