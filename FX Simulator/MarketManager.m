//
//  MarketLoader.m
//  FX Simulator
//
//  Created  on 2014/11/13.
//  
//

#import "MarketManager.h"
#import "Market.h"

@implementation MarketManager

static Market *sharedMarket = nil;

+(Market*)sharedMarket
{
    @synchronized(self) {
        if (sharedMarket == nil) {
            sharedMarket = [Market new];
        }
    }
    
    return sharedMarket;
}

@end
