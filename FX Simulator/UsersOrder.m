//
//  UsersOrder.m
//  FX Simulator
//
//  Created  on 2014/09/08.
//  
//

#import "UsersOrder.h"

#import "OpenPosition.h"
#import "SaveLoader.h"
#import "SaveData.h"
#import "ForexHistoryData.h"
#import "OrderType.h"
#import "PositionSize.h"
#import "Lot.h"

@implementation UsersOrder

+(UsersOrder*)createFromCurrencyPair:(CurrencyPair*)currencyPair orderType:(OrderType*)orderType positionSize:(PositionSize*)positionSize rate:(Rate*)rate orderSpread:(Spread*)spread
{
    return [[UsersOrder alloc] initWithCurrencyPair:currencyPair orderType:orderType orderRate:rate positionSize:positionSize orderSpread:spread];
}

-(BOOL)includeCloseOrder
{
    OpenPosition *openPosition = [OpenPosition loadOpenPosition];
    
    if ([self.orderType isEqualOrderType:openPosition.orderType]) {
        return NO;
    } else {
        return YES;
    }
}

/*+(UsersOrder*)createFromOrderType:(OrderType *)orderType positionSize:(PositionSize *)positionSize rate:(Rate*)rate
{
    SaveData *saveData = [SaveLoader load];
    
    //PositionSize *positionSize = saveData.tradePositionSize;
    //PositionSize *positionSize = [[PositionSize alloc] initWithSizeValue:saveData.positionSizeOfLot*saveData.lot.lotValue];
    
    return [[UsersOrder alloc] initWithCurrencyPair:saveData.currencyPair orderType:orderType orderRate:rate positionSize:positionSize orderSpread:saveData.spread];
}*/

-(void)setShort
{
    //_orderType = @"SELL";
    //self.orderType.isShort = YES;
}

-(void)setLong
{
    //_orderType = @"BUY";
    //self.orderType.isLong = YES;
}

/*-(BOOL)isValid
{
    if (_ratesID <= 0 || _orderType == nil || _orderRate <= 0 || _lot <= 0) {
        return false;
    }
    
    return true;
}*/


@end
