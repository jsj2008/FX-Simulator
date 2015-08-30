//
//  ExecutionOrdersFactory.m
//  FX Simulator
//
//  Created  on 2014/11/21.
//  
//

#import "ExecutionOrdersFactory.h"

#import "ExecutionOrdersCreator.h"
#import "OpenPosition.h"

@implementation ExecutionOrdersFactory {
    ExecutionOrdersCreator *creator;
}

- (instancetype)initWithOpenPosition:(OpenPosition *)openPosition
{
    if (self = [super init]) {
        creator = [[ExecutionOrdersCreator alloc] initWithOpenPosition:openPosition];
    }
    
    return self;
}

- (NSArray *)create:(Order *)order
{
    return [creator create:order];
}

@end
