//
//  ExecutionOrdersFactory.m
//  FX Simulator
//
//  Created  on 2014/11/21.
//  
//

#import "ExecutionOrdersFactory.h"
#import "ExecutionOrdersCreator.h"
#import "OpenPositionFactory.h"
#import "OpenPosition.h"

@implementation ExecutionOrdersFactory {
    ExecutionOrdersCreator *creator;
}

/*-(id)init
{
    if (self = [super init]) {
        OpenPosition *openPosition = [OpenPositionFactory createOpenPosition];
        creator = [[ExecutionOrdersCreator alloc] initWithOpenPosition:openPosition];
    }
    
    return self;
}*/

-(id)initWithOpenPosition:(OpenPosition *)openPosition
{
    if (self = [super init]) {
        creator = [[ExecutionOrdersCreator alloc] initWithOpenPosition:openPosition];
    }
    
    return self;
}

-(NSArray*)create:(ExecutionOrderMaterial*)order
{
    return [creator create:order];
}

@end
