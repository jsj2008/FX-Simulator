//
//  FXTimestamp.h
//  FX Simulator
//
//  Created  on 2015/01/17.
//  
//

#import "Common.h"

@interface MarketTime : NSObject
-(instancetype)initWithTimestamp:(timestamp_t)timestamp;
-(instancetype)initWithDate:(NSDate*)date;
-(NSString*)toDisplayTimeString;
-(NSString*)toDisplayYMDString;
-(NSString*)toDisplayHMSString;
@property (nonatomic, readonly) timestamp_t timestampValue;
@property (nonatomic, readonly) NSNumber *timestampValueObj;
@property (nonatomic, readonly) NSDate *date;
@end
