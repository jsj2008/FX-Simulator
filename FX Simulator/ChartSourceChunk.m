//
//  ChartSourceChunk.m
//  FX Simulator
//
//  Created by yuu on 2015/07/17.
//
//

#import "ChartSourceChunk.h"

#import "ChartSource.h"
#import "MarketTimeScale.h"
#import "Setting.h"

@implementation ChartSourceChunk {
    NSArray *_chartSourceArray;
}

- (instancetype)initWithChartSourceArray:(NSArray *)chartSourceArray
{
    if (self = [super init]) {
        _chartSourceArray = chartSourceArray;
    }
    
    if (_chartSourceArray.count == 0) {
        return nil;
    }
    
    return self;
}

- (instancetype)initWithDefaultAndMainChartCurrencyPair:(CurrencyPair *)currencyPair mainChartTimeScale:(MarketTimeScale *)timeScale
{
    NSMutableArray *array = [NSMutableArray array];
        
    for (MarketTimeScale *settingTimeScale in [Setting timeScaleList]) {
        if ([timeScale isEqualToTimeScale:settingTimeScale]) {
            ChartSource *source = [[ChartSource alloc] initWithDefaultAndChartIndex:0 currencyPair:currencyPair timeScale:timeScale isMainChart:YES];
            [array addObject:source];
        }
    }
        
    [[self getTimeScaleArrayExcept:timeScale fromTimeScaleArray:[Setting timeScaleList]] enumerateObjectsUsingBlock:^(MarketTimeScale *obj, NSUInteger idx, BOOL *stop) {
            ChartSource *source = [[ChartSource alloc] initWithDefaultAndChartIndex:idx currencyPair:currencyPair timeScale:obj isMainChart:NO];
            [array addObject:source];
        }];
    
    return [self initWithChartSourceArray:[array copy]];
}

- (ChartSourceChunk *)createFromChartSourceDictionaryArray:(NSArray *)dictionaryArray
{
    NSMutableArray *sourceArray = [NSMutableArray array];
    
    for (NSDictionary *dic in dictionaryArray) {
        ChartSource *source = [[ChartSource alloc] initWithDictionary:dic];
        if (!source) {
            [sourceArray addObject:source];
        }
    }
    
    return [self initWithChartSourceArray:sourceArray];
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

@end
