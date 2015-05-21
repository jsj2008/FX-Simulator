//
//  OrderManagerFactory.h
//  FX Simulator
//
//  Created  on 2014/12/17.
//  
//

#import <Foundation/Foundation.h>

@class OrderManager;

@interface OrderManagerFactory : NSObject
+(OrderManager*)createOrderManager;
@end
