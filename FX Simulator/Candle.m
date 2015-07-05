//
//  Candle.m
//  FX Simulator
//
//  Created  on 2014/10/30.
//  
//

#import "Candle.h"

@implementation Candle

-(void)stroke
{
    [[UIColor colorWithRed:self.colorR green:self.colorG blue:self.colorB alpha:1.0] setStroke];
    [[UIColor colorWithRed:self.colorR green:self.colorG blue:self.colorB alpha:1.0] setFill];
    
    UIBezierPath *rectangle =
    [UIBezierPath bezierPathWithRect:CGRectMake(self.rect.origin.x, self.rect.origin.y, self.rect.size.width, self.rect.size.height)];
    rectangle.lineWidth = 0;
    [rectangle fill];
    [rectangle stroke];
    
    UIBezierPath *highLine = [UIBezierPath bezierPath];
    highLine.lineWidth = 2;
    [highLine moveToPoint:self.highLineBottom];
    [highLine addLineToPoint:self.highLineTop];
    [highLine fill];
    [highLine stroke];
    
    UIBezierPath *lowLine = [UIBezierPath bezierPath];
    lowLine.lineWidth = 2;
    [lowLine moveToPoint:self.lowLineTop];
    [lowLine addLineToPoint:self.lowLineBottom];
    [lowLine fill];
    [lowLine stroke];
}

@end
