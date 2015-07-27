//
//  TimeScaleUtils.m
//  FX Simulator
//
//  Created  on 2014/12/02.
//  
//

#import "TimeScaleUtils.h"

#import "TimeFrame.h"

@implementation TimeScaleUtils

+(NSArray*)selectTimeScaleListExecept:(TimeFrame*)timeScale fromTimeScaleList:(NSArray *)list
{
    NSMutableArray *array = [NSMutableArray array];

    for (TimeFrame *marketTimeScale in list) {
        if (timeScale.minute != marketTimeScale.minute) {
            [array addObject:marketTimeScale];
        }
    }
    
    return [array copy];
}

@end
