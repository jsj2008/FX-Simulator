//
//  FXSTimeRange.m
//  FX Simulator
//
//  Created by yuu on 2015/06/18.
//
//

#import "FXSTimeRange.h"

#import "Time.h"

@implementation FXSTimeRange

-(instancetype)initWithRangeStart:(Time *)start end:(Time *)end
{
    if (start == nil || end == nil) {
        return nil;
    }
    
    if ([start compareTime:end] == NSOrderedDescending) {
        return nil;
    }
    
    if (self = [super init]) {
        _start = start;
        _end = end;
    }
    
    return self;
}

@end
