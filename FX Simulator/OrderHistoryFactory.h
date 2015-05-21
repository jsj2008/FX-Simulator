//
//  OrderHistoryFactory.h
//  FX Simulator
//
//  Created  on 2014/12/11.
//  
//

#import <Foundation/Foundation.h>

@class OrderHistory;

@interface OrderHistoryFactory : NSObject
+(OrderHistory*)createOrderHistory;
@end
