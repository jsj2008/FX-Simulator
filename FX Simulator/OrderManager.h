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
@class Result;

@protocol OrderManagerState <NSObject>
- (Result *)isOrderable:(Order *)order;
@end

@protocol OrderManagerDelegate <NSObject>
- (void)didOrder:(Result *)result;
@end

@interface OrderManager : NSObject
+ (instancetype)createOrderManagerFromOpenPositions:(OpenPositionRelationChunk *)openPositions;
- (void)addDelegate:(id<OrderManagerDelegate>)delegate;
- (void)addState:(id<OrderManagerState>)state;
- (void)order:(Order *)order;
@end
