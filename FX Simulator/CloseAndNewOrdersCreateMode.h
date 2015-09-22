//
//  CloseAndNewExecutionOrdersCreateMode.h
//  FX Simulator
//
//  Created  on 2014/11/22.
//  
//

#import "OrdersCreateMode.h"

@class OpenPositionRelationChunk;

@interface CloseAndNewOrdersCreateMode : OrdersCreateMode
- (instancetype)initWithOpenPositions:(OpenPositionRelationChunk *)openPositions;
@end
