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

+ (NSArray *)createCandlesFromForexHistoryDataChunk:(ForexDataChunk *)chunk displayForexDataCount:(NSInteger)count chartViewWidth:(float)width chartViewHeight:(float)height
{
    NSMutableArray *array = [NSMutableArray array];
    
    float spaceBetweenCandles = 2.0;
    NSUInteger numberOfCandle = count;
    float candleWidth = (width-spaceBetweenCandles*numberOfCandle-spaceBetweenCandles)/numberOfCandle;
    double maxRate = [chunk getMaxRateLimit:count].rateValue;
    double minRate = [chunk getMinRateLimit:count].rateValue;
    float pipDispSize = height/(maxRate - minRate);
    
    [chunk enumerateForexDataUsingBlock:^(ForexHistoryData *obj, NSUInteger idx) {
        NSUInteger candleNumber = idx;
        double open = obj.open.rateValue;
        double close = obj.close.rateValue;
        double high = obj.high.rateValue;
        double low = obj.low.rateValue;
        float candlePositionX = width - ((candleNumber + 1) * (candleWidth + spaceBetweenCandles));
        
        float candlePositionY;
        float candleHeight;
        CGPoint highLineTop;
        CGPoint highLineBottom;
        CGPoint lowLineTop;
        CGPoint lowLineBottom;
        float colorR;
        float colorG;
        float colorB;
        
        // candle pos
        if (open < close) {
            candlePositionY = (maxRate - close) * pipDispSize;
            candleHeight = (close - open) * pipDispSize;
            colorR = 35.0/255.0;
            colorG = 172.0/255.0;
            colorB = 14.0/255.0;
        } else if (open > close) {
            candlePositionY = (maxRate - open) * pipDispSize;
            candleHeight = (open - close) * pipDispSize;
            colorR = 199.0/250.0;
            colorG = 36.0/255.0;
            colorB = 58.0/255.0;
        } else {
            candlePositionY = (maxRate - open) * pipDispSize;
            candleHeight = 1;
            colorR = 35.0/255.0;
            colorG = 172.0/255.0;
            colorB = 14.0/255.0;
        }
        
        if (1 > candleHeight) {
            candleHeight = 1;
        }
        
        // candle high-low line ひげ
        highLineBottom = CGPointMake((candlePositionX+candleWidth/2.0), candlePositionY);
        highLineTop = CGPointMake((candlePositionX+candleWidth/2.0), (maxRate - high)*pipDispSize);
        lowLineTop = CGPointMake((candlePositionX+candleWidth/2.0), (candlePositionY + candleHeight));
        lowLineBottom = CGPointMake(candlePositionX+candleWidth/2.0, (maxRate - low)*pipDispSize);
        
        SimpleCandle *candle = [SimpleCandle new];
        candle.rect = CGRectMake(candlePositionX, candlePositionY, candleWidth, candleHeight);
        candle.highLineTop = highLineTop;
        candle.highLineBottom = highLineBottom;
        candle.lowLineTop = lowLineTop;
        candle.lowLineBottom = lowLineBottom;
        
        candle.colorR = colorR;
        candle.colorG = colorG;
        candle.colorB = colorB;
        candle.forexHistoryData = obj;
        
        [array addObject:candle];
    } limit:count];
    
    return [array copy];
}

@end
