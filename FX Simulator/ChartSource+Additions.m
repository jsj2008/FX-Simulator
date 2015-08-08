//
//  ChartSource+Additions.m
//  FXSimulator
//
//  Created by yuu on 2015/08/08.
//
//

#import "ChartSource+Additions.h"

@implementation ChartSource (Additions)

#pragma mark - getter,setter

- (void)setFxsChartIndex:(NSUInteger)fxsChartIndex
{
    self.chartIndex = (int)fxsChartIndex;
}

- (NSUInteger)fxsChartIndex
{
    return self.chartIndex;
}

- (void)setFxsCurrencyPair:(CurrencyPair *)fxsCurrencyPair
{
    self.currencyPair = fxsCurrencyPair;
}

- (CurrencyPair *)fxsCurrencyPair
{
    return self.currencyPair;
}

- (void)setFxsIsSelected:(BOOL)fxsIsSelected
{
    self.isSelected = fxsIsSelected;
}

- (BOOL)isSelected
{
    return self.isSelected;
}

- (void)setFxsTimeFrame:(TimeFrame *)fxsTimeFrame
{
    self.timeFrame = fxsTimeFrame;
}

- (TimeFrame *)fxsTimeFrame
{
    return self.timeFrame;
}

@end
