//
//  OpenPositionRelationChunk.m
//  FXSimulator
//
//  Created by yuu on 2015/09/20.
//
//

#import "OpenPositionRelationChunk.h"

#import "OpenPosition.h"

@implementation OpenPositionRelationChunk {
    NSUInteger _saveSlot;
}

- (instancetype)initWithSaveSlot:(NSUInteger)slot
{
    if (self = [super init]) {
        _saveSlot = slot;
    }
    
    return self;
}

- (NSArray *)selectNewestFirstLimit:(NSUInteger)limit currencyPair:(CurrencyPair *)currencyPair
{
    return [OpenPosition selectNewestFirstLimit:limit currencyPair:currencyPair saveSlot:_saveSlot];
}

- (NSArray *)selectCloseTargetOpenPositionsLimitClosePositionSize:(PositionSize *)limitPositionSize closeTargetPositionType:(PositionType *)positionType currencyPair:(CurrencyPair *)currencyPair
{
    return [OpenPosition selectCloseTargetOpenPositionsLimitClosePositionSize:limitPositionSize closeTargetPositionType:positionType currencyPair:currencyPair saveSlot:_saveSlot];
}

- (PositionType *)positionTypeOfCurrencyPair:(CurrencyPair *)currencyPAir
{
    return [OpenPosition positionTypeOfCurrencyPair:currencyPAir saveSlot:_saveSlot];
}

- (Money *)profitAndLossOfCurrencyPair:(CurrencyPair *)currencyPair ForMarket:(Market *)market InCurrency:(Currency *)currency
{
    return [OpenPosition profitAndLossOfCurrencyPair:currencyPair ForMarket:market InCurrency:currency saveSlot:_saveSlot];
}

- (PositionSize *)totalPositionSizeOfCurrencyPair:(CurrencyPair *)currencyPair
{
    return [OpenPosition totalPositionSizeOfCurrencyPair:currencyPair saveSlot:_saveSlot];
}

- (Rate *)averageRateOfCurrencyPair:(CurrencyPair *)currencyPair
{
    return [OpenPosition averageRateOfCurrencyPair:currencyPair saveSlot:_saveSlot];
}

- (BOOL)isExecutableNewPosition
{
    return [OpenPosition isExecutableNewPositionOfSaveSlot:_saveSlot];
}

- (void)delete
{
    [OpenPosition deleteSaveSlot:_saveSlot];
}

@end
