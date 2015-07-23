//
//  ChartSource.m
//  FX Simulator
//
//  Created by yuu on 2015/07/16.
//
//

#import "ChartPlistSource.h"

#import "Candle.h"
#import "CandlePlistSource.h"
#import "CurrencyPair.h"
#import "Indicator.h"
#import "IndicatorChunk.h"
#import "IndicatorPlistSource.h"
#import "MarketTimeScale.h"

@implementation ChartPlistSource

static const NSUInteger FXSDefaultDisplayForexDataCount = 40;
static NSString* const FXSDisplayForexDataCountKey = @"DisplayForexDataCount";
static NSString* const FXSChartIndexKey = @"ChartIndex";
static NSString* const FXSCurrencyPairKey = @"CurrencyPair";
static NSString* const FXSTimeScaleKey = @"TimeScale";
static NSString* const FXSIsMainChartKey = @"IsMainChart";
static NSString* const FXSIsSubChartKey = @"IsSubChart";
static NSString* const FXSIndicatorSourceDictionaryArrayKey = @"IndicatorSourceDictionaryArray";

- (instancetype)initWithDefaultAndChartIndex:(NSUInteger)index currencyPair:(CurrencyPair *)currencyPair timeScale:(MarketTimeScale *)timeScale isMainChart:(BOOL)isMainChart isSubChart:(BOOL)isSubChart
{
    if (self = [super init]) {
        _displayForexDataCount = FXSDefaultDisplayForexDataCount;
        _chartIndex = index;
        _currencyPair = currencyPair;
        _timeScale = timeScale;
        _isMainChart = isMainChart;
        _isSubChart = isSubChart;
        
        CandlePlistSource *defaultIndicatorSource = [[CandlePlistSource alloc] initWithDefault];
        Candle *defaultIndicator = [[Candle alloc] initWithCandleSource:defaultIndicatorSource];
        
        _displayIndicatorChunk = [[IndicatorChunk alloc] initWithIndicatorArray:@[defaultIndicator]];
    }
    
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    if (self = [super init]) {
        _displayForexDataCount = ((NSNumber *)dic[FXSDisplayForexDataCountKey]).unsignedIntegerValue;
        _chartIndex = ((NSNumber *)dic[FXSChartIndexKey]).unsignedIntegerValue;
        _currencyPair = [[CurrencyPair alloc] initWithCurrencyPairString:dic[FXSCurrencyPairKey]];
        _timeScale = [[MarketTimeScale alloc] initWithMinute:((NSNumber *)dic[FXSTimeScaleKey]).unsignedIntegerValue];
        _isMainChart = ((NSNumber *)dic[FXSIsMainChartKey]).boolValue;
        _isSubChart = ((NSNumber *)dic[FXSIsSubChartKey]).boolValue;
        
        NSArray *indicatorSourceArray = [self toIndicatorSourceArrayFromSourceDictionaryArray:dic[FXSIndicatorSourceDictionaryArrayKey]];
        NSArray *indicatorArray = [self toIndicatorArrayFromSourceArray:indicatorSourceArray];
        _displayIndicatorChunk = [[IndicatorChunk alloc] initWithIndicatorArray:indicatorArray];
    }
    
    return self;
}

- (NSArray *)toIndicatorSourceArrayFromSourceDictionaryArray:(NSArray *)dictionaryArray
{
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSDictionary *dic in dictionaryArray) {
        IndicatorPlistSource *source = [[IndicatorPlistSource alloc] initWithDictionary:dic];
        if (source) {
            [array addObject:source];
        }
    }
    
    return [array copy];
}

- (NSArray *)toIndicatorArrayFromSourceArray:(NSArray *)sourceArray
{
    NSMutableArray *indicatorArray = [NSMutableArray array];
    
    for (IndicatorPlistSource *source in sourceArray) {
        Indicator *indicator = [[Indicator alloc] initWithSource:source];
        if (indicator) {
            [indicatorArray addObject:indicator];
        }
    }
    
    return [indicatorArray copy];
}

- (NSDictionary *)sourceDictionary
{
    if (![self validateChartSource]) {
        return nil;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    dic[FXSDisplayForexDataCountKey] = @(self.displayForexDataCount);
    
    dic[FXSChartIndexKey] = @(self.chartIndex);
    
    if (self.currencyPair) {
        dic[FXSCurrencyPairKey] = self.currencyPair.toCodeString;
    }
    
    if (self.timeScale) {
        dic[FXSTimeScaleKey] = self.timeScale.minuteValueObj;
    }
    
    dic[FXSIsMainChartKey] = @(self.isMainChart);
    
    dic[FXSIsSubChartKey] = @(self.isSubChart);
    
    NSArray *indicatorSourceDictionaryArray = self.displayIndicatorChunk.indicatorSourceDictionaryArray;
    
    if (indicatorSourceDictionaryArray) {
        dic[FXSIndicatorSourceDictionaryArrayKey] = indicatorSourceDictionaryArray;
    }
    
    return [dic copy];
}

- (BOOL)validateChartSource
{
    if (self.displayForexDataCount == 0) {
        return NO;
    }
    
    if (!self.currencyPair) {
        return NO;
    }
    
    if (!self.timeScale) {
        return NO;
    }
    
    if (self.isMainChart == self.isSubChart) {
        return NO;
    }

    return YES;
}

@end
