//
//  NSNumber+FXSNumberConverter.m
//  FX Simulator
//
//  Created by yuu on 2015/07/03.
//
//

#import "NSNumber+FXSNumberConverter.h"

@implementation NSNumber (FXSNumberConverter)

-(NSString*)fxs_toDisplayString
{
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setGroupingSeparator:@","];
    [formatter setGroupingSize:3];
    
    return [formatter stringFromNumber:self];
}

@end
