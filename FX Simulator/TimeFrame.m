//
//  MarketTimeScale.m
//  FX Simulator
//
//  Created  on 2014/12/02.
//  
//

#import "TimeFrame.h"

@implementation TimeFrame

-(id)initWithMinute:(int)minute
{
    if (!(0 < minute)) {
        return nil;
    }
    
    if (self = [super init]) {
        _minute = minute;
    }
    
    return self;
}

-(BOOL)isEqual:(id)other {
    if (other == self) {
        return YES;
    } else if ([other isKindOfClass:[self class]]) {
        if ([self isEqualToTimeFrame:other]) {
            return YES;
        }
    }
    
    return NO;
}

-(BOOL)isEqualToTimeFrame:(TimeFrame*)timeFrame
{
    if (self.minute == timeFrame.minute) {
        return YES;
    }
    
    return NO;
}

- (NSComparisonResult)compare:(TimeFrame *)timeFrame
{
    return [self.minuteValueObj compare:timeFrame.minuteValueObj];
}

-(NSString*)toDisplayString
{
    int dayTimeScaleMinute = 1440;
    int hourTimeScaleMinute = 60;
    
    if (dayTimeScaleMinute <= self.minute) {
        if (dayTimeScaleMinute == self.minute) {
            return @"日足";
        } else {
            return [NSString stringWithFormat:@"%d足", self.minute / dayTimeScaleMinute];
        }
    } else if (hourTimeScaleMinute <= self.minute) {
        return [NSString stringWithFormat:@"%d時間足", self.minute / hourTimeScaleMinute];
    } else if (0 < self.minute) {
        return [NSString stringWithFormat:@"%d分足", self.minute];
    }
    
    return nil;
}

-(NSNumber*)minuteValueObj
{
    return [NSNumber numberWithInt:self.minute];
}

@end
