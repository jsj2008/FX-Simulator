//
//  Position.m
//  FXSimulator
//
//  Created by yuu on 2015/08/30.
//
//

#import "PositionBase.h"

@implementation PositionBase

- (instancetype)initWithCurrencyPair:(CurrencyPair *)currencyPair positionType:(PositionType *)positionType rate:(Rate *)rate positionSize:(PositionSize *)positionSize
{
    if (self = [super init]) {
        _currencyPair = currencyPair;
        _positionType = positionType;
        _rate = rate;
        _positionSize = positionSize;
    }
    
    return self;
}

@end
