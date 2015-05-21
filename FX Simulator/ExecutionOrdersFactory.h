//
//  ExecutionOrdersFactory.h
//  FX Simulator
//
//  Created  on 2014/11/21.
//  
//

#import <Foundation/Foundation.h>

@class OpenPosition;
@class ExecutionOrderMaterial;

@interface ExecutionOrdersFactory : NSObject
-(id)initWithOpenPosition:(OpenPosition*)openPosition;
-(NSArray*)create:(ExecutionOrderMaterial*)order;
@end
