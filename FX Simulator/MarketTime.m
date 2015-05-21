//
//  FXTimestamp.m
//  FX Simulator
//
//  Created  on 2015/01/17.
//  
//

#import "MarketTime.h"

@implementation MarketTime

-(instancetype)initWithTimestamp:(timestamp_t)timestamp
{
    if (self = [super init]) {
        _timestampValue = timestamp;
        _timestampValueObj = [NSNumber numberWithInt:_timestampValue];
    }
    
    return self;
}

-(instancetype)initWithDate:(NSDate *)date
{
    return [self initWithTimestamp:[date timeIntervalSince1970]];
}

-(NSString*)toDisplayTimeString
{
    NSTimeInterval interval = _timestampValue;
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"yyyy/MM/dd hh:mm:ss";
    
    return [dateFormatter stringFromDate:date];
}

-(NSString*)toDisplayYMDString
{
    NSTimeInterval interval = _timestampValue;
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"yyyy/MM/dd";
    
    return [dateFormatter stringFromDate:date];
}

-(NSString*)toDisplayHMSString
{
    NSTimeInterval interval = _timestampValue;
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"hh:mm:ss";
    
    return [dateFormatter stringFromDate:date];
}

-(NSDate*)date
{
    return [NSDate dateWithTimeIntervalSince1970:self.timestampValue];
}

@end
