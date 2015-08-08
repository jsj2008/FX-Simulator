//
//  CandleSource+Additions.m
//  FXSimulator
//
//  Created by yuu on 2015/08/08.
//
//

#import "CandleSource+Additions.h"

@implementation CandleSource (Additions)

- (void)setFxsDownColor:(UIColor *)fxsDownColor
{
    self.downColor = fxsDownColor;
}

- (UIColor *)fxsDownColor
{
    return self.downColor;
}

- (void)setFxsDownLineColor:(UIColor *)fxsDownLineColor
{
    self.downLineColor = fxsDownLineColor;
}

- (UIColor *)fxsDownLineColor
{
    return self.downLineColor;
}

- (void)setFxsUpColor:(UIColor *)fxsUpColor
{
    self.upColor = fxsUpColor;
}

- (UIColor *)fxsUpColor
{
    return self.upColor;
}

- (void)setFxsUpLineColor:(UIColor *)fxsUpLineColor
{
    self.upLineColor = fxsUpLineColor;
}

- (UIColor *)fxsUpLineColor
{
    return self.upLineColor;
}

@end
