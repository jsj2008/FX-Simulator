//
//  ChartChunk.m
//  FX Simulator
//
//  Created by yuu on 2015/07/18.
//
//

#import "ChartChunk.h"

#import "Chart.h"
#import "ChartSource.h"
#import "CurrencyPair.h"
#import "MarketTimeScale.h"
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

- (instancetype)initWithDefaultAndMainChartCurrencyPair:(CurrencyPair *)currencyPair mainChartTimeScale:(MarketTimeScale *)timeScale
{
    NSMutableArray *sourceArray = [NSMutableArray array];
    
    for (MarketTimeScale *settingTimeScale in [Setting timeScaleList]) {
        if ([timeScale isEqualToTimeScale:settingTimeScale]) {
            ChartSource *source = [[ChartSource alloc] initWithDefaultAndChartIndex:0 currencyPair:currencyPair timeScale:timeScale isMainChart:YES isSubChart:NO];
            [sourceArray addObject:source];
        }
    }
    
    [[self getTimeScaleArrayExcept:timeScale fromTimeScaleArray:[Setting timeScaleList]] enumerateObjectsUsingBlock:^(MarketTimeScale *obj, NSUInteger idx, BOOL *stop) {
        ChartSource *source = [[ChartSource alloc] initWithDefaultAndChartIndex:idx currencyPair:currencyPair timeScale:obj isMainChart:NO isSubChart:YES];
        [sourceArray addObject:source];
    }];
    
    NSArray *chartArray = [self toChartArrayFromChartSourceArray:sourceArray];
    
    return [self initWithChartArray:chartArray];
}

- (NSArray *)toChartArrayFromChartSourceArray:(NSArray *)sourceArray
{
    NSMutableArray *chartArray = [NSMutableArray array];
    
    for (ChartSource *source in sourceArray) {
        Chart *chart = [[Chart alloc] initWithChartSource:source];
        if (chart) {
            [chartArray addObject:chart];
        }
    }
    
    return [chartArray copy];
}

-(NSArray *)getTimeScaleArrayExcept:(MarketTimeScale *)exceptTimeScale fromTimeScaleArray:(NSArray *)timeScaleArray
{
    NSMutableArray *array = [NSMutableArray array];
    
    for (MarketTimeScale *timeScale in timeScaleArray) {
        if (![exceptTimeScale isEqualToTimeScale:timeScale]) {
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
        ChartSource *chartSource = [[ChartSource alloc] initWithDictionary:sourceDictionary];
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
