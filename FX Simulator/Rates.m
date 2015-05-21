//
//  Rates.m
//  FX Simulator
//
//  Created  on 2015/03/29.
//  
//

#import "Rates.h"

#import "Rate.h"
#import "SaveData.h"
#import "SaveLoader.h"

@implementation Rates

-(instancetype)initWithBidRtae:(Rate*)bidRate
{
    if (bidRate == nil) {
        return nil;
    }
    
    if (self = [super init]) {
        _bidRate = bidRate;
        SaveData *saveData = [SaveLoader load];
        _askRate = [_bidRate addSpread:saveData.spread];
    }
    
    return self;
}

@end
