//
//  FXTimestamp.m
//  FX Simulator
//
//  Created  on 2015/01/17.
//  
//

#import "Time.h"

static NSString* const FXSTimeKey = @"time";

@implementation Time

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    return [self initWithDate:[aDecoder decodeObjectForKey:FXSTimeKey]];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.date forKey:FXSTimeKey];
}

-(instancetype)initWithTimestamp:(timestamp_t)timestamp
{
    if (self = [super init]) {
        _timestampValue = timestamp;
        _timestampValueObj = [NSNumber numberWithInt:_timestampValue];
        _date = [NSDate dateWithTimeIntervalSince1970:self.timestampValue];
    }
    
    return self;
}

-(instancetype)initWithDate:(NSDate *)date
{
    return [self initWithTimestamp:[date timeIntervalSince1970]];
}

- (Time *)addDay:(int)day
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *comps1 = [[NSDateComponents alloc]init];
    comps1.day = day;
    NSDate *result = [calendar dateByAddingComponents:comps1 toDate:self.date options:0];
    
    return [[Time alloc] initWithDate:result];
}

- (NSComparisonResult)compareTime:(Time *)time
{
    return [self.date compare:time.date];
}

- (BOOL)isEqualTime:(Time *)time
{
    NSComparisonResult result = [self compareTime:time];
    
    if (result == NSOrderedSame) {
        return YES;
    } else {
        return NO;
    }
}

- (NSString *)toDisplayTimeString
{
    NSTimeInterval interval = _timestampValue;
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"yyyy/MM/dd hh:mm:ss";
    
    return [dateFormatter stringFromDate:date];
}

- (NSString *)toDisplayYMDString
{
    NSTimeInterval interval = _timestampValue;
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"yyyy/MM/dd";
    
    return [dateFormatter stringFromDate:date];
}

- (NSString *)toDisplayHMSString
{
    NSTimeInterval interval = _timestampValue;
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"hh:mm:ss";
    
    return [dateFormatter stringFromDate:date];
}

@end
