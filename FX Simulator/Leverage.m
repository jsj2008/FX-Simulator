//
//  Leverage.m
//  FXSimulator
//
//  Created by yuu on 2016/01/07.
//
//

#import "Leverage.h"

@implementation Leverage

- (instancetype)initWithLeverage:(NSUInteger)leverage
{
    if (self = [super init]) {
        _leverage = leverage;
    }
    
    return self;
}

- (instancetype)initWithLeverageNumber:(NSNumber *)leverageNumber
{
    return [self initWithLeverage:leverageNumber.integerValue];
}

- (NSNumber *)leverageNumber
{
    return @(self.leverage);
}

- (NSString *)stringValue
{
    return self.leverageNumber.stringValue;
}

@end
