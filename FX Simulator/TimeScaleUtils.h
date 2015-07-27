//
//  TimeScaleUtils.h
//  FX Simulator
//
//  Created  on 2014/12/02.
//  
//

#import <Foundation/Foundation.h>

@class TimeFrame;

@interface TimeScaleUtils : NSObject
+(NSArray*)selectTimeScaleListExecept:(TimeFrame*)timeScale fromTimeScaleList:(NSArray*)list;
@end
