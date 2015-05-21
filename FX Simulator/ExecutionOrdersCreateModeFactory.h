//
//  ExecutionOrdersCreateModeFactory.h
//  FX Simulator
//
//  Created  on 2014/11/22.
//  
//

#import <Foundation/Foundation.h>

@class OpenPosition;
@class ExecutionOrdersCreateMode;
@class ExecutionOrderMaterial;

@interface ExecutionOrdersCreateModeFactory : NSObject
-(id)initWithOpenPosition:(OpenPosition*)openPosition;
-(ExecutionOrdersCreateMode*)createMode:(ExecutionOrderMaterial*)order;
@end
