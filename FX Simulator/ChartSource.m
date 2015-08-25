//
//  ChartSource.m
//  FXSimulator
//
//  Created by yuu on 2015/08/25.
//
//

#import "ChartSource.h"
#import "CandleSource.h"
#import "SaveDataSource.h"
#import "SimpleMovingAverageSource.h"


@implementation ChartSource

@dynamic chartIndex;
@dynamic currencyPair;
@dynamic displayDataCount;
@dynamic isSelected;
@dynamic timeFrame;
@dynamic candleSource;
@dynamic saveDataSourceForMain;
@dynamic saveDataSourceForSub;
@dynamic simpleMovingAverageSources;

@end
