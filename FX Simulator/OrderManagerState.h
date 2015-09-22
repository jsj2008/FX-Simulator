//
//  OrderManagerState.h
//  FXSimulator
//
//  Created by yuu on 2015/09/07.
//
//

#import "OrderManager.h"

@class OpenPositionRelationChunk;
@class Order;
@class OrderResult;

@interface OrderManagerState : NSObject <OrderManagerState>
- (instancetype)initWithOpenPositions:(OpenPositionRelationChunk *)openPositions;
- (void)addState:(id<OrderManagerState>)state;
- (OrderResult *)isOrderable:(Order *)order;
@end
