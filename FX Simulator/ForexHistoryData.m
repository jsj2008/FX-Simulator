//
//  ForexHistoryData.m
//  FX Simulator
//
//  Created  on 2014/10/30.
//  
//

#import "ForexHistoryData.h"

#import "FMResultSet.h"
#import "Rate.h"
#import "MarketTime.h"
#import "ForexHistoryDataArrayUtils.h"

@implementation ForexHistoryData

-(id)initWithFMResultSet:(FMResultSet*)rs currencyPair:(CurrencyPair *)currencyPair
{
    if (self = [self init]) {
        _ratesID = [rs intForColumn:@"rowid"];
        _currencyPair = currencyPair;
        MarketTime *openTimestamp = [[MarketTime alloc] initWithTimestamp:[rs intForColumn:@"open_minute_open_timestamp"]];
        MarketTime *closeTimestamp = [[MarketTime alloc] initWithTimestamp:[rs intForColumn:@"close_minute_close_timestamp"]];
        _open = [[Rate alloc] initWithRateValue:[rs doubleForColumn:@"open"] currencyPair:currencyPair timestamp:openTimestamp];
        _close = [[Rate alloc] initWithRateValue:[rs doubleForColumn:@"close"] currencyPair:currencyPair timestamp:closeTimestamp];
        _high = [[Rate alloc] initWithRateValue:[rs doubleForColumn:@"high"] currencyPair:currencyPair timestamp:nil];
        _low = [[Rate alloc] initWithRateValue:[rs doubleForColumn:@"low"] currencyPair:currencyPair timestamp:nil];
        
        _previous = [ForexHistoryData new];
    }
    
    return self;
}

-(id)initWithForexHistoryDataArray:(NSArray*)array
{
    if (self = [self init]) {
        _currencyPair = ((ForexHistoryData*)[array firstObject]).currencyPair;
        _open = ((ForexHistoryData*)[array firstObject]).open;
        _close = ((ForexHistoryData*)[array lastObject]).close;
        _high = [[Rate alloc] initWithRateValue:[ForexHistoryDataArrayUtils maxRateOfArray:array] currencyPair:_currencyPair timestamp:nil];
        _low = [[Rate alloc] initWithRateValue:[ForexHistoryDataArrayUtils minRateOfArray:array] currencyPair:_currencyPair timestamp:nil];
        
        _previous = [ForexHistoryData new];
    }
    
    return self;
}

-(NSString*)displayOpenTimestamp
{
    return self.open.timestamp.toDisplayTimeString;
}

-(NSString*)displayCloseTimestamp
{
    return self.close.timestamp.toDisplayTimeString;
}

@end
