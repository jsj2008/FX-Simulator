//
//  OrderRelationChunk.m
//  FXSimulator
//
//  Created by yuu on 2016/01/14.
//
//

#import "OrderRelationChunk.h"

#import "Order.h"

@implementation OrderRelationChunk {
    NSUInteger _saveSlot;
}

- (instancetype)initWithSaveSlot:(NSUInteger)slot
{
    if (self = [super init]) {
        _saveSlot = slot;
    }
    
    return self;
}

- (void)delete
{
    [Order deleteSaveSlot:_saveSlot];
}

@end
