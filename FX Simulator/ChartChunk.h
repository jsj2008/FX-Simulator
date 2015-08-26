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

@property (nonatomic) Chart *displayChart;

- (instancetype)initWithChartArray:(NSArray *)chartArray;

/**
 ChartIndexの順番に取り出す。 
*/
- (void)enumerateCharts:(void (^)(Chart *chart))block;

/**
 ChartIndexがindexなチャート。
*/
- (Chart *)getChartFromChartIndex:(NSUInteger)index;

- (BOOL)existsChart;

@end
