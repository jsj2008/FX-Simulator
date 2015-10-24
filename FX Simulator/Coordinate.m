//
//  Coordinate.m
//  FXSimulator
//
//  Created by yuu on 2015/10/24.
//
//

#import "Coordinate.h"

@implementation Coordinate

- (instancetype)initWithCoordinateValue:(float)value
{
    if (self = [super init]) {
        _value = value;
    }
    
    return self;
}

@end
