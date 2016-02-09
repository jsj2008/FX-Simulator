//
//  NSDate+FXSDateData.m
//  FX Simulator
//
//  Created  on 2015/05/06.
//  
//

#import "NSDate+FXSDateData.h"

#import "Setting.h"

@implementation NSDate (FXSDateData)

-(NSUInteger)fxs_year
{
    NSCalendar *calendar = [Setting calendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:self];
    
    return components.year;
}

-(NSUInteger)fxs_month
{
    NSCalendar *calendar = [Setting calendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:self];
    
    return components.month;
}

-(NSUInteger)fxs_day
{
    NSCalendar *calendar = [Setting calendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:self];
    
    return components.day;
}

@end
