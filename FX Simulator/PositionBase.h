//
//  Position.h
//  FXSimulator
//
//  Created by yuu on 2015/08/30.
//
//

#import "TradeDatabase.h"

@class CurrencyPair;
@class Time;
@class PositionSize;
@class PositionType;
@class Rate;

@interface PositionBase : TradeDatabase {
    NSUInteger _saveSlot;
    CurrencyPair *_currencyPair;
    PositionType *_positionType;
    Rate *_rate;
    PositionSize *_positionSize;
}

/*@property (nonatomic ,readonly) CurrencyPair *currencyPair;
@property (nonatomic, readonly) PositionType *positionType;
@property (nonatomic, readonly) Rate *rate;
@property (nonatomic, readonly) PositionSize *positionSize;*/

- (instancetype)initWithSaveSlot:(NSUInteger)slot CurrencyPair:(CurrencyPair *)currencyPair positionType:(PositionType *)positionType rate:(Rate *)rate positionSize:(PositionSize *)positionSize;

@end
