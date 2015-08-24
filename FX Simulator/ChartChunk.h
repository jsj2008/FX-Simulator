//
//  ChartChunk.h
//  FX Simulator
//
//  Created by yuu on 2015/07/18.
//
//

#import <Foundation/Foundation.h>


@class Chart;
@class CurrencyPair;
@class TimeFrame;

@interface ChartChunk : NSObject
- (instancetype)initWithChartArray:(NSArray *)chartArray;

/**
 表示順に取り出す。 
*/
- (void)enumerateCharts:(void (^)(Chart *chart))block;

/**
 ChartIndexがindexなチャート。
*/
- (Chart *)chartOfChartIndex:(NSUInteger)index;

- (Chart *)selectedChart;

- (BOOL)existsChart;

@end
