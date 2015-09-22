//
//  OrderManager.h
//  FXSimulator
//
//  Created by yuu on 2015/09/05.
//
//

#import <Foundation/Foundation.h>

@class OpenPositionRelationChunk;
@class Order;
@class OrderResult;

@protocol OrderManagerState <NSObject>
- (OrderResult *)isOrderable:(Order *)order;
@end

@protocol OrderManagerDelegate <NSObject>
- (void)didOrder:(OrderResult *)result;
@end

@interface OrderManager : NSObject
+ (instancetype)createOrderManagerFromOpenPositions:(OpenPositionRelationChunk *)openPositions;
- (void)addDelegate:(id<OrderManagerDelegate>)delegate;
- (void)addState:(id<OrderManagerState>)state;
- (void)order:(Order *)order;
@end
