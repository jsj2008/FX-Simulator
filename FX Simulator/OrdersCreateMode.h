//
//  ExecutionOrdersCreateMode.h
//  FX Simulator
//
//  Created  on 2014/11/22.
//  
//

#import <Foundation/Foundation.h>

@class Order;

@interface OrdersCreateMode : NSObject
- (NSArray *)create:(Order *)order;
@end
