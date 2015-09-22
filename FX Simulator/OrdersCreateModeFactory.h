//
//  ExecutionOrdersCreateModeFactory.h
//  FX Simulator
//
//  Created  on 2014/11/22.
//  
//

#import <Foundation/Foundation.h>

@class OpenPositionRelationChunk;
@class Order;
@class OrdersCreateMode;

@interface OrdersCreateModeFactory : NSObject
- (instancetype)initWithOpenPositions:(OpenPositionRelationChunk *)openPositions;
- (OrdersCreateMode *)createModeFromOrder:(Order *)order;
@end
