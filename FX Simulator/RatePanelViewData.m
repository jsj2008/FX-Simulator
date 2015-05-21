//
//  RatePanelViewData.m
//  FX Simulator
//
//  Created  on 2014/11/20.
//  
//

#import "RatePanelViewData.h"

#import "ForexHistoryData.h"
#import "Market.h"
#import "OrderType.h"
#import "Rate.h"
#import "SaveLoader.h"
#import "SaveData.h"


@implementation RatePanelViewData {
    Market *_market;
    SaveData *saveData;
}

-(id)init
{
    if (self = [super init]) {
        saveData = [SaveLoader load];
    }
    
    return self;
}

-(void)updateCurrentMarket:(Market *)market
{
    _market = market;
}

-(NSString*)getDisplayCurrentBidRate
{
    return [[_market getCurrentBidRate] toDisplayString];
}

-(NSString*)getDisplayCurrentAskRate
{
    return [[_market getCurrentAskRate] toDisplayString];
}

-(Rate*)getCurrentRateForOrderType:(OrderType *)orderType
{
    if (orderType.isShort) {
        // return Bid Rate
        return [_market getCurrentBidRate];
    } else if (orderType.isLong) {
        // return Ask Rate
        return [_market getCurrentAskRate];
    }
    
    return nil;
}

-(PositionSize*)currentPositionSize
{
    return saveData.tradePositionSize;
}

-(CurrencyPair*)currencyPair
{
    return saveData.currencyPair;
}

-(Spread*)spread
{
    return saveData.spread;
}

@end
