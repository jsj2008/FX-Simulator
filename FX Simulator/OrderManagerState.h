//
//  OrderManagerState.h
//  FXSimulator
//
//  Created by yuu on 2015/09/07.
//
//

#import "OrderManager.h"

@class Order;
@class OrderResult;

@interface OrderManagerState : NSObject <OrderManagerState>
- (void)addState:(id<OrderManagerState>)state;
- (OrderResult *)isOrderable:(Order *)order;
@end
