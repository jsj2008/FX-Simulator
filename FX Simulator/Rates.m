//
//  Rates.m
//  FX Simulator
//
//  Created  on 2015/03/29.
//  
//

#import "Rates.h"

#import "Rate.h"

@implementation Rates

-(instancetype)initWithBidRtae:(Rate *)bidRate spread:(Spread *)spread
{
    if (!bidRate || !spread) {
        return nil;
    }
    
    if (self = [super init]) {
        _bidRate = bidRate;
        _askRate = [_bidRate addSpread:spread];
    }
    
    return self;
}

@end
