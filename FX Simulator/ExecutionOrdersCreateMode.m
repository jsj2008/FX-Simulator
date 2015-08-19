//
//  ExecutionOrdersCreateMode.m
//  FX Simulator
//
//  Created  on 2014/11/22.
//  
//

#import "ExecutionOrdersCreateMode.h"

#import "OpenPosition.h"

@implementation ExecutionOrdersCreateMode

-(id)init
{
    return nil;
}

-(id)initWithOpenPosition:(OpenPosition *)openPosition
{
    if (self = [super init]) {
        _openPosition = openPosition;
    }
    
    return self;
}

-(NSArray*)create:(ExecutionOrderMaterial *)order
{
    [self.openPosition update];
    
    return nil;
}

@end
