//
//  CandleChart.m
//  FX Simulator
//
//  Created by yuu on 2015/07/05.
//
//

#import "Candle.h"

#import "SimpleCandle.h"
#import "CandleSource.h"
#import "CandlesFactory.h"
#import "ForexDataChunk.h"

@implementation Candle {
    CandleSource *_source;
}

+ (instancetype)createDefaultCandle
{
    UIColor *upColor = [UIColor colorWithRed:35.0/255.0 green:172.0/255.0 blue:14.0/255.0 alpha:1.0];
    UIColor *downColor = [UIColor colorWithRed:199.0/250.0 green:36.0/255.0 blue:58.0/255.0 alpha:1.0];
    
    CandleSource *source = [CandleSource new];
    source.displayOrder = 0;
    
    Candle *candle = [[Candle alloc] initWithCandleSource:source];
    candle.upColor = upColor;
    candle.upLineColor = upColor;
    candle.downColor = downColor;
    candle.downLineColor = downColor;
    
    return candle;
}

- (instancetype)initWithIndicatorSource:(IndicatorSource *)source
{
    return nil;
}

- (instancetype)initWithCandleSource:(CandleSource *)source
{
    if (self = [super initWithIndicatorSource:source]) {
        _source = source;
    }
    
    return self;
}

- (void)strokeIndicatorFromForexDataChunk:(ForexDataChunk *)chunk displayForexDataCount:(NSInteger)count displaySize:(CGSize)size
{
    if (chunk == nil) {
        return;
    }
    
    NSArray *candles = [CandlesFactory createCandlesFromForexHistoryDataChunk:chunk displayForexDataCount:count chartViewWidth:size.width chartViewHeight:size.height];
    
    for (SimpleCandle *candle in candles) {
        [candle stroke];
    }
}

#pragma mark - getter,setter

- (UIColor *)downColor
{
    return _source.downColor;
}

- (void)setDownColor:(UIColor *)downColor
{
    _source.downColor = downColor;
}

- (UIColor *)downLineColor
{
    return _source.downLineColor;
}

- (void)setDownLineColor:(UIColor *)downLineColor
{
    _source.downLineColor = downLineColor;
}

- (UIColor *)upColor
{
    return _source.upColor;
}

- (void)setUpColor:(UIColor *)upColor
{
    _source.upColor = upColor;
}

- (UIColor *)upLineColor
{
    return _source.upLineColor;
}

- (void)setUpLineColor:(UIColor *)upLineColor
{
    _source.upLineColor = upLineColor;
}

@end
