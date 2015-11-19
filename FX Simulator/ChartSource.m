//
//  ChartSource.m
//  FXSimulator
//
//  Created by yuu on 2015/11/19.
//
//

#import "ChartSource.h"
#import "BollingerBandsSource.h"
#import "CandleSource.h"
#import "HeikinAshiSource.h"
#import "MovingAverageSource.h"
#import "SaveDataSource.h"


@implementation ChartSource

@dynamic chartIndex;
@dynamic currencyPair;
@dynamic displayDataCount;
@dynamic isDisplay;
@dynamic timeFrame;
@dynamic type;
@dynamic bollingerBandsSources;
@dynamic candleSource;
@dynamic heikinAshiSources;
@dynamic movingAverageSources;
@dynamic saveDataSource;

@end
