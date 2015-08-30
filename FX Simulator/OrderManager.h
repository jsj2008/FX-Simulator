//
//  OrderManager.h
//  FX Simulator
//
//  Created  on 2014/09/11.
//  
//

#import <Foundation/Foundation.h>

@class Order;
@class OrderHistory;
@class ExecutionOrdersFactory;
@class ExecutionOrdersManager;
@class UIViewController;

/**
 ユーザーからのOrder(注文)を実行するクラス。
 ユーザーのOrder(USersOrder)から、実行するためのOrder(ExecutionOrder)に変換して、それを実行する。
*/

@interface OrderManager : NSObject
+ (instancetype)createOrderManager;
- (instancetype)initWithOrderHistory:(OrderHistory*)orderHistory executionOrdersFactory:(ExecutionOrdersFactory*)executionOrdersFactory executionOrdersManager:(ExecutionOrdersManager*)executionOrdersManager;
- (BOOL)execute:(Order *)order;
@property (nonatomic, weak) UIViewController *alertTarget;
@end
