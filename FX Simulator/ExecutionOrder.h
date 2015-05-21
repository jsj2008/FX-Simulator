//
//  ExecutionOrder.h
//  FX Simulator
//
//  Created  on 2014/11/23.
//  
//

#import "Order.h"

@interface ExecutionOrder : Order
@property (nonatomic, readwrite) int orderID;
@property (nonatomic, readonly) int usersOrderNumber;
//@property (nonatomic, readwrite) int executionHistoryNumber;
@end
