//
//  OrderManager.h
//  FX Simulator
//
//  Created  on 2014/09/11.
//  
//

#import <Foundation/Foundation.h>

@class UsersOrder;
@class OrderHistory;
@class ExecutionOrdersFactory;
@class ExecutionOrdersManager;

/**
 ユーザーからのOrder(注文)を実行するクラス。
 ユーザーのOrder(USersOrder)から、実行するためのOrder(ExecutionOrder)に変換して、それを実行する。
*/

@interface OrderManager : NSObject
-(id)initWithOrderHistory:(OrderHistory*)orderHistory executionOrdersFactory:(ExecutionOrdersFactory*)executionOrdersFactory executionOrdersManager:(ExecutionOrdersManager*)executionOrdersManager;
-(BOOL)execute:(UsersOrder*)order error:(NSError**)anError;
@end
