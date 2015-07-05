//
//  CandlesFactory.m
//  FX Simulator
//
//  Created  on 2014/10/30.
//  
//

#import "CandlesFactory.h"

#import "Candle.h"
#import "ForexHistoryDataArrayUtils.h"
#import "ForexHistoryData.h"
#import "Rate.h"

#import "IndicatorUtils.h"

@implementation CandlesFactory

+(NSMutableArray*)createCandlesFromForexHistoryDataArray:(NSArray *)forexHistoryDataArray chartViewWidth:(float)width chartViewHeight:(float)height
{
    NSMutableArray *array = [NSMutableArray array];
    
    float spaceBetweenCandles = 2.0;
    int numberOfCandle = (int)[forexHistoryDataArray count];
    float candleWidth = (width-spaceBetweenCandles*numberOfCandle-spaceBetweenCandles)/numberOfCandle;
    double maxRate = [ForexHistoryDataArrayUtils maxRateOfArray:forexHistoryDataArray];
    double minRate = [ForexHistoryDataArrayUtils minRateOfArray:forexHistoryDataArray];
    float pipDispSize = height/(maxRate - minRate);
    
    int candleNumber = 0;
    
    for (ForexHistoryData* forexHistoryData in forexHistoryDataArray) {
        double open = forexHistoryData.open.rateValue;
        double close = forexHistoryData.close.rateValue;
        double high = forexHistoryData.high.rateValue;
        double low = forexHistoryData.low.rateValue;
        float candlePositionX = candleNumber*(candleWidth+spaceBetweenCandles) + spaceBetweenCandles;
        /*if (candleNumber == 0) {
            candlePositionX = spaceBetweenCandles;
        }*/
        float candlePositionY;
        float candleHeight;
        CGPoint highLineTop;
        CGPoint highLineBottom;
        CGPoint lowLineTop;
        CGPoint lowLineBottom;
        float colorR;
        float colorG;
        float colorB;
        
        /*candleUpColorRGB = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:35.0/255.0], @"R", [NSNumber numberWithFloat:172.0/255.0], @"G", [NSNumber numberWithFloat:14.0/255.0], @"B", nil];
        candleDownColorRGB = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:199.0/250.0], @"R", [NSNumber numberWithFloat:36.0/255.0], @"G", [NSNumber numberWithFloat:58.0/255.0], @"B", nil];*/
        
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
        /*int highLineBottomX = candlePositionX+candleWidth/2.0;
        int highLineBottomY = candlePositionY;
        int x1 = candlePositionX+candleWidth/2.0;
        int y1 = (maxRate - high)*pipDispSize;
        highLineBottom = CGPointMake(highLineBottomX, highLineBottomY);
        highLineTop = CGPointMake(x1, y1);*/
        highLineBottom = CGPointMake((candlePositionX+candleWidth/2.0), candlePositionY);
        highLineTop = CGPointMake((candlePositionX+candleWidth/2.0), (maxRate - high)*pipDispSize);
        lowLineTop = CGPointMake((candlePositionX+candleWidth/2.0), (candlePositionY + candleHeight));
        lowLineBottom = CGPointMake(candlePositionX+candleWidth/2.0, (maxRate - low)*pipDispSize);
        
        Candle *candle = [Candle new];
        candle.rect = CGRectMake(candlePositionX, candlePositionY, candleWidth, candleHeight);
        candle.highLineTop = highLineTop;
        candle.highLineBottom = highLineBottom;
        candle.lowLineTop = lowLineTop;
        candle.lowLineBottom = lowLineBottom;
        
        //candle.rect = CGRectIntegral(candle.rect);
        
        candle.colorR = colorR;
        candle.colorG = colorG;
        candle.colorB = colorB;
        candle.forexHistoryData = forexHistoryData;
        
        [array addObject:candle];
        
        candleNumber++;
    }
    
    return [array copy];
}

@end
