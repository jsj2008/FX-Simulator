//
//  ChartChunk.m
//  FX Simulator
//
//  Created by yuu on 2015/07/18.
//
//

#import "ChartChunk.h"

#import "Chart.h"
#import "ChartPlistSource.h"
#import "CurrencyPair.h"
#import "TimeFrame.h"
#import "Setting.h"

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

- (instancetype)initWithDefaultAndMainChartCurrencyPair:(CurrencyPair *)currencyPair mainChartTimeScale:(TimeFrame *)timeScale
{
    NSMutableArray *sourceArray = [NSMutableArray array];
    
    for (TimeFrame *settingTimeScale in [Setting timeScaleList]) {
        if ([timeScale isEqualToTimeFrame:settingTimeScale]) {
            ChartPlistSource *source = [[ChartPlistSource alloc] initWithDefaultAndChartIndex:0 currencyPair:currencyPair timeScale:timeScale isMainChart:YES isSubChart:NO];
            [sourceArray addObject:source];
        }
    }
    
    [[self getTimeScaleArrayExcept:timeScale fromTimeScaleArray:[Setting timeScaleList]] enumerateObjectsUsingBlock:^(TimeFrame *obj, NSUInteger idx, BOOL *stop) {
        ChartPlistSource *source = [[ChartPlistSource alloc] initWithDefaultAndChartIndex:idx currencyPair:currencyPair timeScale:obj isMainChart:NO isSubChart:YES];
        [sourceArray addObject:source];
    }];
    
    NSArray *chartArray = [self toChartArrayFromChartSourceArray:sourceArray];
    
    return [self initWithChartArray:chartArray];
}

- (NSArray *)toChartArrayFromChartSourceArray:(NSArray *)sourceArray
{
    NSMutableArray *chartArray = [NSMutableArray array];
    
    for (ChartPlistSource *source in sourceArray) {
        Chart *chart = [[Chart alloc] initWithChartSource:source];
        if (chart) {
            [chartArray addObject:chart];
        }
    }
    
    return [chartArray copy];
}

-(NSArray *)getTimeScaleArrayExcept:(TimeFrame *)exceptTimeScale fromTimeScaleArray:(NSArray *)timeScaleArray
{
    NSMutableArray *array = [NSMutableArray array];
    
    for (TimeFrame *timeScale in timeScaleArray) {
        if (![exceptTimeScale isEqualToTimeFrame:timeScale]) {
            [array addObject:timeScale];
        }
    }
    
    return [array copy];
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

+ (ChartChunk *)createFromChartSourceDictionaryArray:(NSArray *)dictionaryArray
{
    NSMutableArray *chartArray = [NSMutableArray array];
    
    for (NSDictionary *sourceDictionary in dictionaryArray) {
        ChartPlistSource *chartSource = [[ChartPlistSource alloc] initWithDictionary:sourceDictionary];
        Chart *chart = [[Chart alloc] initWithChartSource:chartSource];
        if (chart) {
            [chartArray addObject:chart];
        }
    }
    
    return [[ChartChunk alloc] initWithChartArray:chartArray];
}

- (NSArray *)chartSourceDictionaryArray
{
    NSMutableArray *chartSourceDictionaryArray = [NSMutableArray array];
    
    for (Chart *chart in _chartArray) {
        NSDictionary *chartSourceDictionary = chart.chartSourceDictionary;
        if (chartSourceDictionary) {
            [chartSourceDictionaryArray addObject:chartSourceDictionary];
        }
    }
    
    return chartSourceDictionaryArray;
}

@end
