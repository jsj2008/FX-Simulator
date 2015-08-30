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

-(BOOL)includeCloseOrder
{
    OpenPosition *openPosition = [OpenPosition loadOpenPosition];
    
    if ([self.orderType isEqualOrderType:[openPosition orderTypeOfCurrencyPair:self.currencyPair]]) {
        return NO;
    } else {
        return YES;
    }
}

@end
