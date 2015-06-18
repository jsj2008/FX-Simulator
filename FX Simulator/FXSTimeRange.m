//
//  FXSTimeRange.m
//  FX Simulator
//
//  Created by yuu on 2015/06/18.
//
//

#import "FXSTimeRange.h"

#import "MarketTime.h"

@implementation FXSTimeRange

-(instancetype)initWithRangeStart:(MarketTime *)start end:(MarketTime *)end
{
    if (start == nil || end == nil) {
        return nil;
    }
    
    if ([start compare:end] == NSOrderedDescending) {
        return nil;
    }
    
    if (self = [super init]) {
        _start = start;
        _end = end;
    }
    
    return self;
}

@end
