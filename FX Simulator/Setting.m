//
//  Setting.m
//  FX Simulator
//
//  Created  on 2014/12/02.
//  
//

#import "Setting.h"

#import "Currency.h"
#import "CurrencyPair.h"
#import "ForexHistory.h"
#import "ForexHistoryFactory.h"
#import "FXSTimeRange.h"
#import "MarketTime.h"
#import "TimeFrame.h"
#import "Rate.h"


static NSDictionary *spreadRateDic;

@implementation Setting

+(void)initialize
{
    Rate *eurusd = [[Rate alloc] initWithRateValue:0.0001 currencyPair:[[CurrencyPair alloc] initWithCurrencyPairString:@"EURUSD"] timestamp:nil];
    Rate *usdjpy = [[Rate alloc] initWithRateValue:0.01 currencyPair:[[CurrencyPair alloc] initWithCurrencyPairString:@"USDJPY"] timestamp:nil];
    Rate *gbpusd = [[Rate alloc] initWithRateValue:0.0001 currencyPair:[[CurrencyPair alloc] initWithCurrencyPairString:@"GBPUSD"] timestamp:nil];
    Rate *audusd = [[Rate alloc] initWithRateValue:0.0001 currencyPair:[[CurrencyPair alloc] initWithCurrencyPairString:@"AUDUSD"] timestamp:nil];
    Rate *eurjpy = [[Rate alloc] initWithRateValue:0.01 currencyPair:[[CurrencyPair alloc] initWithCurrencyPairString:@"EURJPY"] timestamp:nil];
    Rate *gbpjpy = [[Rate alloc] initWithRateValue:0.01 currencyPair:[[CurrencyPair alloc] initWithCurrencyPairString:@"GBPJPY"] timestamp:nil];
    Rate *audjpy = [[Rate alloc] initWithRateValue:0.01 currencyPair:[[CurrencyPair alloc] initWithCurrencyPairString:@"AUDJPY"] timestamp:nil];
    
    spreadRateDic = @{@"EURUSD":eurusd,
            @"USDJPY":usdjpy,
            @"GBPUSD":gbpusd,
            @"AUDUSD":audusd,
            @"EURJPY":eurjpy,
            @"GBPJPY":gbpjpy,
            @"AUDJPY":audjpy
          };
}

+(BOOL)isLocaleJapanese
{
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *languageID = [languages objectAtIndex:0];
    
    if ([languageID isEqualToString:@"ja"]) {
        return YES;
    }
    
    return NO;
}

+(NSArray*)currencyPairList
{
    Currency *usd = [[Currency alloc] initWithCurrencyType:USD];
    Currency *jpy = [[Currency alloc] initWithCurrencyType:JPY];
    Currency *eur = [[Currency alloc] initWithCurrencyType:EUR];
    Currency *gbp = [[Currency alloc] initWithCurrencyType:GBP];
    Currency *aud = [[Currency alloc] initWithCurrencyType:AUD];
    
    CurrencyPair *EURUSD = [[CurrencyPair alloc] initWithBaseCurrency:eur QuoteCurrency:usd];
    CurrencyPair *USDJPY = [[CurrencyPair alloc] initWithBaseCurrency:usd QuoteCurrency:jpy];
    CurrencyPair *EURJPY = [[CurrencyPair alloc] initWithBaseCurrency:eur QuoteCurrency:jpy];
    CurrencyPair *GBPJPY = [[CurrencyPair alloc] initWithBaseCurrency:gbp QuoteCurrency:jpy];
    CurrencyPair *AUDJPY = [[CurrencyPair alloc] initWithBaseCurrency:aud QuoteCurrency:jpy];
    CurrencyPair *GBPUSD = [[CurrencyPair alloc] initWithBaseCurrency:gbp QuoteCurrency:usd];
    CurrencyPair *AUDUSD = [[CurrencyPair alloc] initWithBaseCurrency:aud QuoteCurrency:usd];
    
    if ([Setting isLocaleJapanese]) {
        return @[USDJPY, EURUSD, EURJPY, GBPJPY, AUDJPY, GBPUSD, AUDUSD];
    } else {
        return @[EURUSD, USDJPY, GBPUSD, AUDUSD, EURJPY, GBPJPY, AUDJPY];
    }
}

+(NSDictionary*)currencyPairDictionaryList
{
#warning CurrencyPairList(static変数)から生成
    Currency *usd = [[Currency alloc] initWithCurrencyType:USD];
    Currency *jpy = [[Currency alloc] initWithCurrencyType:JPY];
    Currency *eur = [[Currency alloc] initWithCurrencyType:EUR];
    Currency *gbp = [[Currency alloc] initWithCurrencyType:GBP];
    Currency *aud = [[Currency alloc] initWithCurrencyType:AUD];
    
    CurrencyPair *EURUSD = [[CurrencyPair alloc] initWithBaseCurrency:eur QuoteCurrency:usd];
    CurrencyPair *USDJPY = [[CurrencyPair alloc] initWithBaseCurrency:usd QuoteCurrency:jpy];
    CurrencyPair *EURJPY = [[CurrencyPair alloc] initWithBaseCurrency:eur QuoteCurrency:jpy];
    CurrencyPair *GBPJPY = [[CurrencyPair alloc] initWithBaseCurrency:gbp QuoteCurrency:jpy];
    CurrencyPair *AUDJPY = [[CurrencyPair alloc] initWithBaseCurrency:aud QuoteCurrency:jpy];
    CurrencyPair *GBPUSD = [[CurrencyPair alloc] initWithBaseCurrency:gbp QuoteCurrency:usd];
    CurrencyPair *AUDUSD = [[CurrencyPair alloc] initWithBaseCurrency:aud QuoteCurrency:usd];
    
    NSDictionary *dic = @{@"EURUSD":EURUSD, @"USDJPY":USDJPY, @"EURJPY":EURJPY, @"GBPJPY":GBPJPY, @"AUDJPY":AUDJPY, @"GBPUSD":GBPUSD, @"AUDUSD":AUDUSD};
    
    return dic;
}

+(NSArray*)timeScaleList
{
    
    return @[[[TimeFrame alloc] initWithMinute:15], [[TimeFrame alloc] initWithMinute:60], [[TimeFrame alloc] initWithMinute:240], [[TimeFrame alloc] initWithMinute:1440]];
}

+(NSArray*)accountCurrencyList
{
    if ([Setting isLocaleJapanese]) {
        return @[[[Currency alloc] initWithCurrencyType:JPY], [[Currency alloc] initWithCurrencyType:USD]];
    } else {
        return @[[[Currency alloc] initWithCurrencyType:USD], [[Currency alloc] initWithCurrencyType:JPY]];
    }
}

+(Rate*)onePipValueOfCurrencyPair:(CurrencyPair*)currencyPair
{
    /*Rate *eurusd = [[Rate alloc] initWithRateValue:0.0001 currencyPair:[[CurrencyPair alloc] initWithCurrencyPairString:@"EURUSD"] timestamp:nil];
    Rate *usdjpy = [[Rate alloc] initWithRateValue:0.01 currencyPair:[[CurrencyPair alloc] initWithCurrencyPairString:@"USDJPY"] timestamp:nil];
    Rate *gbpusd = [[Rate alloc] initWithRateValue:0.0001 currencyPair:[[CurrencyPair alloc] initWithCurrencyPairString:@"GBPUSD"] timestamp:nil];
    Rate *audusd = [[Rate alloc] initWithRateValue:0.0001 currencyPair:[[CurrencyPair alloc] initWithCurrencyPairString:@"AUDUSD"] timestamp:nil];
    Rate *eurjpy = [[Rate alloc] initWithRateValue:0.01 currencyPair:[[CurrencyPair alloc] initWithCurrencyPairString:@"EURJPY"] timestamp:nil];
    Rate *gbpjpy = [[Rate alloc] initWithRateValue:0.01 currencyPair:[[CurrencyPair alloc] initWithCurrencyPairString:@"GBPJPY"] timestamp:nil];
    Rate *audjpy = [[Rate alloc] initWithRateValue:0.01 currencyPair:[[CurrencyPair alloc] initWithCurrencyPairString:@"AUDJPY"] timestamp:nil];
    
    NSDictionary *dic = @{@"EURUSD":eurusd,
                          @"USDJPY":usdjpy,
                          @"GBPUSD":gbpusd,
                          @"AUDUSD":audusd,
                          @"EURJPY":eurjpy,
                          @"GBPJPY":gbpjpy,
                          @"AUDJPY":audjpy
                          };*/
    /*NSDictionary *dic = @{@"EURUSD":[NSNumber numberWithDouble:0.0001],
                          @"USDJPY":[NSNumber numberWithDouble:0.01],
                          @"GBPUSD":[NSNumber numberWithDouble:0.0001],
                          @"AUDUSD":[NSNumber numberWithDouble:0.0001],
                          @"EURJPY":[NSNumber numberWithDouble:0.01],
                          @"GBPJPY":[NSNumber numberWithDouble:0.01],
                          @"AUDJPY":[NSNumber numberWithDouble:0.01]
                          };*/
    
    return [spreadRateDic objectForKey:currencyPair.toCodeString];
}

+(NSString*)toStringFromRate:(Rate *)rate
{
    if ([rate.currencyPair isQuoteCurrencyEqualJPY]) {
        NSNumberFormatter* formatter = [NSNumberFormatter new];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        formatter.minimumFractionDigits = 2;
        formatter.maximumFractionDigits = 2;
        return [formatter stringFromNumber:rate.rateValueObj];
    } else {
        NSNumberFormatter* formatter = [NSNumberFormatter new];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        formatter.minimumFractionDigits = 4;
        formatter.maximumFractionDigits = 4;
        return [formatter stringFromNumber:rate.rateValueObj];
    }
}

+(Rate*)baseRateOfCurrencyPair:(CurrencyPair*)currencyPair
{
    NSDictionary *dic = @{@"EURUSD":[NSNumber numberWithDouble:1.3],
                          @"USDJPY":[NSNumber numberWithDouble:100],
                          @"GBPUSD":[NSNumber numberWithDouble:1.6],
                          @"AUDUSD":[NSNumber numberWithDouble:0.9],
                          @"EURJPY":[NSNumber numberWithDouble:130],
                          @"GBPJPY":[NSNumber numberWithDouble:170],
                          @"AUDJPY":[NSNumber numberWithDouble:80]
                          };
    
    NSNumber *rate = ((NSNumber*)[dic objectForKey:currencyPair.toCodeString]);
    
    if (rate != nil) {
        return [[Rate alloc] initWithRateValue:[rate doubleValue] currencyPair:currencyPair timestamp:nil];
    } else {
        rate = ((NSNumber*)[dic objectForKey:currencyPair.toCodeReverseString]);
        if (rate != nil) {
            double doubleRate = 1 / [rate doubleValue];
            return [[Rate alloc] initWithRateValue:doubleRate currencyPair:currencyPair timestamp:nil];
        } else {
            return nil;
        }
    }
}

+(FXSTimeRange*)rangeForCurrencyPair:(CurrencyPair *)currencyPair timeScale:(TimeFrame *)timeScale
{
    ForexHistory *forexHistory = [ForexHistoryFactory createForexHistoryFromCurrencyPair:currencyPair timeScale:timeScale];
    
    MarketTime *rangeStart = [[forexHistory minOpenTime] addDay:50];
    MarketTime *rangeEnd = [[forexHistory maxOpenTime] addDay:-50];
    
    return [[FXSTimeRange alloc] initWithRangeStart:rangeStart end:rangeEnd];
}

+ (NSUInteger)maxDisplayForexDataCountOfChartView
{
    return 250;
}

+ (NSUInteger)maxIndicatorTerm
{
    return 200;
}

@end
