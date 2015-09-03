//
//  FXTimestamp.h
//  FX Simulator
//
//  Created  on 2015/01/17.
//  
//

#import "Common.h"

@interface Time : NSObject <NSCoding>
@property (nonatomic, readonly) NSDate *date;
@property (nonatomic, readonly) timestamp_t timestampValue;
@property (nonatomic, readonly) NSNumber *timestampValueObj;
- (instancetype)initWithDate:(NSDate*)date;
- (instancetype)initWithTimestamp:(timestamp_t)timestamp;
- (Time *)addDay:(int)day;
- (NSComparisonResult)compare:(Time*)time;
- (BOOL)isEqualTime:(Time *)time;
- (NSString *)toDisplayTimeString;
- (NSString *)toDisplayYMDString;
- (NSString *)toDisplayHMSString;
@end
