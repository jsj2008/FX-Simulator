//
//  ChartSource.m
//  FXSimulator
//
//  Created by yuu on 2015/11/18.
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
@dynamic candleSource;
@dynamic saveDataSourceForMain;
@dynamic saveDataSourceForSub;
@dynamic movingAverageSources;
@dynamic bollingerBandsSources;
@dynamic heikinAshiSources;

@end
