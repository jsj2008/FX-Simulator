//
//  ChartSource+Additions.h
//  FXSimulator
//
//  Created by yuu on 2015/08/08.
//
//

#import "ChartSource.h"

@class CurrencyPair;
@class TimeFrame;

@interface ChartSource (Additions)
@property (nonatomic) NSUInteger fxsChartIndex;
@property (nonatomic, retain) CurrencyPair *fxsCurrencyPair;
@property (nonatomic) BOOL fxsIsSelected;
@property (nonatomic, retain) TimeFrame *fxsTimeFrame;
@end
