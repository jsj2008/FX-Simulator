//
//  ExecutionOrdersCreateMode.h
//  FX Simulator
//
//  Created  on 2014/11/22.
//  
//

#import <Foundation/Foundation.h>

@class ExecutionOrderMaterial;
@class OpenPosition;

/*@protocol ExecutionOrdersCreateMode
-(NSArray*)create:(ExecutionOrderMaterial*)order;
@end*/

@interface ExecutionOrdersCreateMode : NSObject
-(id)initWithOpenPosition:(OpenPosition*)openPosition;
-(NSArray*)create:(ExecutionOrderMaterial*)order __attribute__((objc_requires_super));
@property (nonatomic, readonly) OpenPosition *openPosition;
@end
