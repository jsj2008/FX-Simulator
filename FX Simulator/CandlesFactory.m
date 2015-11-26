//
//  CandlesFactory.m
//  FX Simulator
//
//  Created  on 2014/10/30.
//  
//

#import "CandlesFactory.h"

#import "ForexDataChunk.h"
#import "ForexHistoryDataArrayUtils.h"
#import "ForexHistoryData.h"
#import "IndicatorUtils.h"
#import "Rate.h"
#import "SimpleCandle.h"

@implementation CandlesFactory

+ (NSArray *)createCandlesFromForexHistoryDataChunk:(ForexDataChunk *)chunk displayForexDataCount:(NSInteger)count chartSize:(CGSize)chartSize upColor:(UIColor *)upColor upLineColor:(UIColor *)upLineColor downColor:(UIColor *)downColor downLineColor:(UIColor *)downLineColor
{
    NSMutableArray *array = [NSMutableArray array];
    
    float candleZoneWidth = chartSize.width / count;
    float spaceBetweenCandles = candleZoneWidth * 0.3;
    NSUInteger numberOfCandle = count;
    float candleWidth = candleZoneWidth - spaceBetweenCandles;
    //float candleWidth = (width-spaceBetweenCandles*numberOfCandle-spaceBetweenCandles)/numberOfCandle;
    double maxRate = [chunk getMaxRateLimit:count].rateValue;
    double minRate = [chunk getMinRateLimit:count].rateValue;
    float pipDispSize = chartSize.height/(maxRate - minRate);
    
    [chunk enumerateForexDataUsingBlock:^(ForexHistoryData *obj, NSUInteger idx) {
        NSUInteger candleNumber = idx;
        double open = obj.open.rateValue;
        double close = obj.close.rateValue;
        double high = obj.high.rateValue;
        double low = obj.low.rateValue;
        float candlePositionX = chartSize.width - ((candleNumber + 1) * (candleWidth + spaceBetweenCandles));
        
        // candle pos
        
        float candlePositionY;
        float candleHeight;
        
        if (open < close) {
            candlePositionY = (maxRate - close) * pipDispSize;
            candleHeight = (close - open) * pipDispSize;
        } else if (open > close) {
            candlePositionY = (maxRate - open) * pipDispSize;
            candleHeight = (open - close) * pipDispSize;
        } else {
            candlePositionY = (maxRate - open) * pipDispSize;
            candleHeight = 1;
        }
        
        if (1 > candleHeight) {
            candleHeight = 1;
        }
        
        // candle color
        
        UIColor *candleColor;
        UIColor *candleLineColor;
        
        if (open > close) {
            candleColor = downColor;
            candleLineColor = downLineColor;
        } else {
            candleColor = upColor;
            candleLineColor = upLineColor;
        }
        
        // candle high-low line ひげ
        
        CGPoint highLineTop;
        CGPoint highLineBottom;
        CGPoint lowLineTop;
        CGPoint lowLineBottom;
        
        highLineBottom = CGPointMake((candlePositionX+candleWidth/2.0), candlePositionY);
        highLineTop = CGPointMake((candlePositionX+candleWidth/2.0), (maxRate - high)*pipDispSize);
        lowLineTop = CGPointMake((candlePositionX+candleWidth/2.0), (candlePositionY + candleHeight));
        lowLineBottom = CGPointMake(candlePositionX+candleWidth/2.0, (maxRate - low)*pipDispSize);
        
        // create candle
        
        SimpleCandle *candle = [SimpleCandle new];
        candle.areaRect = CGRectMake(chartSize.width - (idx + 1) * candleZoneWidth, 0, candleZoneWidth, chartSize.height);
        candle.rect = CGRectMake(candlePositionX, candlePositionY, candleWidth, candleHeight);
        candle.highLineTop = highLineTop;
        candle.highLineBottom = highLineBottom;
        candle.lowLineTop = lowLineTop;
        candle.lowLineBottom = lowLineBottom;
        
        candle.color = candleColor;
        candle.lineColor = candleLineColor;
        
        candle.forexHistoryData = obj;
        
        [array addObject:candle];
        
    } limit:count];
    
    return [array copy];
}

@end
