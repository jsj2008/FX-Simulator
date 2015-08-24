//
//  ChartChunk.m
//  FX Simulator
//
//  Created by yuu on 2015/07/18.
//
//

#import "ChartChunk.h"

#import "Chart.h"
#import "CurrencyPair.h"
#import "TimeFrame.h"

@implementation ChartChunk {
    NSArray *_chartArray;
}

- (instancetype)initWithChartArray:(NSArray *)chartArray
{
    if (self = [super init]) {
        _chartArray = chartArray;
    }
    
    return self;
}

- (void)enumerateCharts:(void (^)(Chart *))block
{
    NSArray *chartArray = [_chartArray sortedArrayUsingSelector:@selector(compareDisplayOrder:)];
    
    [chartArray enumerateObjectsUsingBlock:^(Chart *obj, NSUInteger idx, BOOL *stop) {
        block(obj);
    }];
}

- (Chart *)chartOfChartIndex:(NSUInteger)index
{
    for (Chart *chart in _chartArray) {
        if ([chart isEqualChartIndex:index]) {
            return chart;
        }
    }
    
    return nil;
}

- (Chart *)selectedChart
{
    __block Chart *selectedChart;
    
    [self enumerateCharts:^(Chart *chart) {
        if (chart.isSelected) {
            selectedChart = chart;
        }
    }];
    
    return selectedChart;
}

- (BOOL)existsChart
{
    if (0 < _chartArray.count) {
        return YES;
    } else {
        return NO;
    }
}

@end
