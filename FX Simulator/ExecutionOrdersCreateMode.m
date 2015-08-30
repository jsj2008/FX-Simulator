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

- (instancetype)init
{
    return nil;
}

- (instancetype)initWithOpenPosition:(OpenPosition *)openPosition
{
    if (self = [super init]) {
        _openPosition = openPosition;
    }
    
    return self;
}

- (NSArray *)create:(Order *)order
{
    [self.openPosition update];
    
    return nil;
}

@end
