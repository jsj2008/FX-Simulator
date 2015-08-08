//
//  SimpleMovingAverageSource+Additions.m
//  FXSimulator
//
//  Created by yuu on 2015/08/08.
//
//

#import "SimpleMovingAverageSource+Additions.h"

@implementation SimpleMovingAverageSource (Additions)

- (void)setFxsLineColor:(UIColor *)fxsLineColor
{
    self.lineColor = fxsLineColor;
}

- (UIColor *)fxsLineColor
{
    return self.lineColor;
}

- (void)setFxsPeriod:(NSUInteger)fxsPeriod
{
    self.period = (int)fxsPeriod;
}

- (NSUInteger)fxsPeriod
{
    return self.period;
}

@end
