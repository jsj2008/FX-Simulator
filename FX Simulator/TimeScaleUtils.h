//
//  TimeScaleUtils.h
//  FX Simulator
//
//  Created  on 2014/12/02.
//  
//

#import <Foundation/Foundation.h>

@class MarketTimeScale;

@interface TimeScaleUtils : NSObject
+(NSArray*)selectTimeScaleListExecept:(MarketTimeScale*)timeScale fromTimeScaleList:(NSArray*)list;
@end
