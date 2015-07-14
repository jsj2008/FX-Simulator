//
//  IndicatorSource.m
//  FX Simulator
//
//  Created by yuu on 2015/07/13.
//
//

#import "IndicatorSource.h"

#import "MarketTimeScale.h"

static NSString* const kIndicatorNameKey = @"IndicatorName";
static NSString* const kDisplayIndexKey = @"DisplayIndex";
static NSString* const kIsMainChartKey = @"kIsMainChartKey";
static NSString* const kTimeScaleKey = @"TimeScale";

@implementation IndicatorSource {
    NSString *_codeName;
}

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    if (dic == nil) {
        return nil;
    }
    
    if (self = [super init]) {
        _indicatorName = dic[kIndicatorNameKey];
        _displayIndex = ((NSNumber *)dic[kDisplayIndexKey]).unsignedIntegerValue;
        _isMainChart = ((NSNumber *)dic[kIsMainChartKey]).boolValue;
        _timeScale = [[MarketTimeScale alloc] initWithMinute:((NSNumber *)dic[kTimeScaleKey]).unsignedIntegerValue];
    }
    
    return self;
}

- (NSDictionary *)sourceDictinary
{
    return @{kIndicatorNameKey:self.indicatorName, kDisplayIndexKey:@(self.displayIndex), kIsMainChartKey:@(self.isMainChart), kTimeScaleKey:self.timeScale.minuteValueObj};
}

+ (NSString *)indicatorNameKey
{
    return kIndicatorNameKey;
}

@end
