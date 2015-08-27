//
//  FXTimestamp.h
//  FX Simulator
//
//  Created  on 2015/01/17.
//  
//

#import "Common.h"

@interface MarketTime : NSObject <NSCoding>
-(instancetype)initWithTimestamp:(timestamp_t)timestamp;
-(instancetype)initWithDate:(NSDate*)date;
-(MarketTime*)addDay:(int)day;
-(NSComparisonResult)compare:(MarketTime*)time;
- (BOOL)isEqualTime:(MarketTime *)time;
-(NSString*)toDisplayTimeString;
-(NSString*)toDisplayYMDString;
-(NSString*)toDisplayHMSString;
@property (nonatomic, readonly) timestamp_t timestampValue;
@property (nonatomic, readonly) NSNumber *timestampValueObj;
@property (nonatomic, readonly) NSDate *date;
@end
