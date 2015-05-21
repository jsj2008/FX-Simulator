//
//  ExecutionOrdersCreator.m
//  FX Simulator
//
//  Created  on 2014/11/21.
//  
//

#import "ExecutionOrdersCreator.h"
#import "ExecutionOrdersCreateModeFactory.h"
#import "ExecutionOrdersCreateMode.h"

@implementation ExecutionOrdersCreator {
    ExecutionOrdersCreateModeFactory *factory;
    ExecutionOrdersCreateMode *mode;
}

/*-(id)init
{
    if (self = [super init]) {
        factory = [ExecutionOrdersCreateModeFactory new];
    }
    
    return self;
}*/

-(id)init
{
    return nil;
}

-(id)initWithOpenPosition:(OpenPosition*)openPosition
{
    if (self = [super init]) {
        factory = [[ExecutionOrdersCreateModeFactory alloc] initWithOpenPosition:openPosition];
    }
    
    return self;
}

-(NSArray*)create:(ExecutionOrderMaterial*)order
{
    mode = [factory createMode:order];
    NSArray *executionOrders = [mode create:order];
    
    return executionOrders;
}

@end
