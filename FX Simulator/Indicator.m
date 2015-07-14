//
//  Indicator.m
//  FX Simulator
//
//  Created by yuu on 2015/07/13.
//
//

#import "Indicator.h"

#import "IndicatorSource.h"
#import "MarketTimeScale.h"

@implementation Indicator {
    IndicatorSource *_source;
}

- (instancetype)init
{
    return nil;
}

- (instancetype)initWithSource:(IndicatorSource *)source
{
    if (self = [super init]) {
        _source = source;
    }
    
    return self;
}

- (NSUInteger)displayIndex
{
    return _source.displayIndex;
}

- (BOOL)isMainChart
{
    return _source.isMainChart;
}

- (MarketTimeScale *)timeScale
{
    return _source.timeScale;
}

- (NSDictionary *)sourceDictionary
{
    return nil;
}

@end
