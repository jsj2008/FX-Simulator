//
//  ChartSource.m
//  FXSimulator
//
//  Created by yuu on 2015/07/27.
//
//

#import "ChartSource.h"
#import "CandleSource.h"
//#import "NSManagedObject.h"
#import "SimpleMovingAverageSource.h"


@implementation ChartSource

@dynamic chartIndex;
@dynamic currencyPair;
@dynamic isSelected;
@dynamic timeFrame;
@dynamic candleSource;
@dynamic saveDataSourceForMain;
@dynamic saveDataSourceForSub;
@dynamic simpleMovingAverageSources;

@end
