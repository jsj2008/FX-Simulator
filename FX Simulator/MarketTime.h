//
//  FXTimestamp.h
//  FX Simulator
//
//  Created  on 2015/01/17.
//  
//

#import "Common.h"

@interface MarketTime : NSObject <NSCoding>
@property (nonatomic, readonly) NSDate *date;
@property (nonatomic, readonly) timestamp_t timestampValue;
@property (nonatomic, readonly) NSNumber *timestampValueObj;
- (instancetype)initWithDate:(NSDate*)date;
- (instancetype)initWithTimestamp:(timestamp_t)timestamp;
- (MarketTime *)addDay:(int)day;
- (NSComparisonResult)compare:(MarketTime*)time;
- (BOOL)isEqualTime:(MarketTime *)time;
- (NSString *)toDisplayTimeString;
- (NSString *)toDisplayYMDString;
- (NSString *)toDisplayHMSString;
@end
