//
//  IndicatorChunk.m
//  FX Simulator
//
//  Created by yuu on 2015/07/13.
//
//

#import "IndicatorChunk.h"

#import "Indicator.h"

@implementation IndicatorChunk {
    NSMutableArray *_indicatorArray;
}

- (instancetype)initWithIndicatorArray:(NSArray *)indicatorArray
{
    if (self = [super init]) {
        _indicatorArray = [indicatorArray mutableCopy];
    }
    
    return self;
}

- (void)enumerateIndicatorsUsingBlock:(void (^) (Indicator *indicator))block
{
    if (!block) {
        return;
    }
    
    NSArray *array = [_indicatorArray sortedArrayUsingSelector:@selector(compareDisplayOrder:)];
    
    /*NSArray *array = [_indicatorArray sortedArrayUsingComparator:^NSComparisonResult(Indicator *obj1, Indicator *obj2) {
        if (obj1.displayOrder < obj2.displayOrder) {
            return NSOrderedAscending;
        } else if (obj1.displayOrder > obj2.displayOrder) {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
    }];*/
    
    [array enumerateObjectsUsingBlock:^(Indicator *obj, NSUInteger idx, BOOL *stop) {
        if (obj) {
            block(obj);
        }
    }];
}

@end
