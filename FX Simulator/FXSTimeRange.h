//
//  FXSTimeRange.h
//  FX Simulator
//
//  Created by yuu on 2015/06/18.
//
//

#import <Foundation/Foundation.h>

@class Time;

@interface FXSTimeRange : NSObject
-(instancetype)initWithRangeStart:(Time*)start end:(Time*)end;
@property (nonatomic, readonly) Time *start;
@property (nonatomic, readonly) Time *end;
@end
