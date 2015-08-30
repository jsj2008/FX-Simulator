//
//  ExecutionOrdersCreateModeFactory.h
//  FX Simulator
//
//  Created  on 2014/11/22.
//  
//

#import <Foundation/Foundation.h>

@class ExecutionOrdersCreateMode;
@class OpenPosition;
@class Order;

@interface ExecutionOrdersCreateModeFactory : NSObject
- (instancetype)initWithOpenPosition:(OpenPosition *)openPosition;
- (ExecutionOrdersCreateMode *)createMode:(Order *)order;
@end
