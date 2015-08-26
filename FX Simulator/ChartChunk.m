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

- (Chart *)getChartFromChartIndex:(NSUInteger)index
{
    for (Chart *chart in _chartArray) {
        if (chart.chartIndex == index) {
            return chart;
        }
    }
    
    return nil;
}

- (BOOL)existsChart
{
    if (0 < _chartArray.count) {
        return YES;
    } else {
        return NO;
    }
}

- (Chart *)displayChart
{
    __block Chart *displayChart;
    
    [self enumerateCharts:^(Chart *chart) {
        if (chart.isDisplay) {
            displayChart = chart;
        }
    }];
    
    return displayChart;
}

- (void)setDisplayChart:(Chart *)displayChart
{
    for (Chart *chart in _chartArray) {
        if (displayChart.chartIndex == chart.chartIndex) {
            chart.isDisplay = YES;
        } else {
            chart.isDisplay = NO;
        }
    }
}

@end
