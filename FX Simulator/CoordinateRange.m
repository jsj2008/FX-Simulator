//
//  ChartDataArea.m
//  FXSimulator
//
//  Created by yuu on 2015/10/24.
//
//

#import "CoordinateRange.h"

@implementation CoordinateRange

- (instancetype)initWithBegin:(Coordinate *)begin end:(Coordinate *)end;
{
    if (!begin || !end) {
        return nil;
    }
    
    if (self = [super init]) {
        _begin = begin;
        _end = end;
    }
    
    return self;
}

@end
