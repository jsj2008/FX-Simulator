//
//  Chart.m
//  FX Simulator
//
//  Created by yuu on 2015/07/18.
//
//

#import "Chart.h"

#import "ChartSource.h"
#import "ForexDataChunk.h"

@implementation Chart {
    ChartSource *_chartSource;
    ForexDataChunk *_currentForexDataChunk;
}

- (instancetype)initWithChartSource:(ChartSource *)source
{
    if (self = [super init]) {
        _chartSource = source;
    }
    
    return self;
}

- (void)setForexDataChunk:(ForexDataChunk *)chunk
{
    _currentForexDataChunk = chunk;
}

- (void)stroke
{
    
}

- (BOOL)isEqualChartIndex:(NSUInteger)index
{
    if (_chartSource.chartIndex == index) {
        return YES;
    }
    
    return NO;
}

- (NSDictionary *)chartSourceDictionary
{
    return _chartSource.sourceDictionary;
}

@end
