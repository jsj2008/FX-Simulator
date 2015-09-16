//
//  ForexHistoryData.m
//  FX Simulator
//
//  Created  on 2014/10/30.
//  
//

#import "ForexHistoryData.h"

#import "FMResultSet.h"
#import "CurrencyPair.h"
#import "Rate.h"
#import "Time.h"
#import "TimeFrame.h"
#import "ForexDataChunk.h"
#import "ForexHistoryDataArrayUtils.h"

@implementation ForexHistoryData

- (instancetype)initWithFMResultSet:(FMResultSet*)rs currencyPair:(CurrencyPair *)currencyPair timeScale:(TimeFrame *)timeScale
{
    if (self = [self init]) {
        _ratesID = [rs intForColumn:@"rowid"];
        _currencyPair = currencyPair;
        _timeScale = timeScale;
        Time *openTimestamp = [[Time alloc] initWithTimestamp:[rs intForColumn:@"open_minute_open_timestamp"]];
        Time *closeTimestamp = [[Time alloc] initWithTimestamp:[rs intForColumn:@"close_minute_close_timestamp"]];
        _open = [[Rate alloc] initWithRateValue:[rs doubleForColumn:@"open"] currencyPair:currencyPair timestamp:openTimestamp];
        _close = [[Rate alloc] initWithRateValue:[rs doubleForColumn:@"close"] currencyPair:currencyPair timestamp:closeTimestamp];
        _high = [[Rate alloc] initWithRateValue:[rs doubleForColumn:@"high"] currencyPair:currencyPair timestamp:nil];
        _low = [[Rate alloc] initWithRateValue:[rs doubleForColumn:@"low"] currencyPair:currencyPair timestamp:nil];
    }
    
    return self;
}

- (instancetype)initWithForexDataChunk:(ForexDataChunk *)chunk timeScale:(TimeFrame *)timeScale
{
    if (!chunk) {
        return nil;
    }
    
    if (self = [self init]) {
        _currencyPair = chunk.current.currencyPair;
        _timeScale = timeScale;
        _open = chunk.oldest.open;
        _close = chunk.current.close;
        _high = [chunk getMaxRate];
        _low = [chunk getMinRate];
    }
    
    return self;
}

- (BOOL)isEqual:(id)object
{
    if (self == object) {
        return YES;
    }
    
    if ([object isKindOfClass:[self class]]) {
        return [self isEqualToForexData:object];
    } else {
        return NO;
    }
}

- (BOOL)isEqualToForexData:(ForexHistoryData *)data
{
    if (self == data) {
        return YES;
    }
    
    if ((self.ratesID == data.ratesID) && [self.currencyPair isEqualCurrencyPair:data.currencyPair] && [self.timeScale isEqualToTimeFrame:data.timeScale]) {
        return YES;
    } else {
        return NO;
    }
}

- (NSComparisonResult)compareTime:(ForexHistoryData *)data
{
    return [self.close.timestamp compare:data.close.timestamp];
}

- (Rate *)getRateForType:(RateType)type
{
    Rate *result;
    
    switch (type) {
        case Open:
            result = self.open;
            break;
            
        case High:
            result = self.high;
            break;
            
        case Low:
            result = self.low;
            break;
            
        case Close:
            result = self.close;
            break;
    }
    
    return result;
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
