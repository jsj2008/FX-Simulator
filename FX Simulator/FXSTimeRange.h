//
//  FXSTimeRange.h
//  FX Simulator
//
//  Created by yuu on 2015/06/18.
//
//

#import <Foundation/Foundation.h>

@class MarketTime;

@interface FXSTimeRange : NSObject
-(instancetype)initWithRangeStart:(MarketTime*)start end:(MarketTime*)end;
@property (nonatomic, readonly) MarketTime *start;
@property (nonatomic, readonly) MarketTime *end;
@end
