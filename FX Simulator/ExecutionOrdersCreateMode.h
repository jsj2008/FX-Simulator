//
//  ExecutionOrdersCreateMode.h
//  FX Simulator
//
//  Created  on 2014/11/22.
//  
//

#import <Foundation/Foundation.h>

@class Order;

@interface ExecutionOrdersCreateMode : NSObject
- (NSArray *)create:(Order *)order __attribute__((objc_requires_super));
@end
