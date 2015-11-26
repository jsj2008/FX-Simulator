//
//  Candle.m
//  FX Simulator
//
//  Created  on 2014/10/30.
//  
//

#import "SimpleCandle.h"

@implementation SimpleCandle

- (void)stroke
{
    UIColor *color = self.color;
    UIColor *lineColor = self.lineColor;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, CGRectMake(self.rect.origin.x, self.rect.origin.y, self.rect.size.width, self.rect.size.height));
    
    
    
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
    
    CGContextMoveToPoint(context, self.highLineBottom.x, self.highLineBottom.y);
    CGContextAddLineToPoint(context, self.highLineTop.x, self.highLineTop.y);
    
    CGContextMoveToPoint(context, self.lowLineTop.x, self.lowLineTop.y);
    CGContextAddLineToPoint(context, self.lowLineBottom.x, self.lowLineBottom.y);
    
    CGContextStrokePath(context);
}

@end
