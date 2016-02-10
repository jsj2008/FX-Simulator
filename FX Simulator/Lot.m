//
//  Lot.m
//  FX Simulator
//
//  Created  on 2014/12/04.
//  
//

#import "Lot.h"

#import "NSNumber+FXSNumberConverter.h"
#import "PositionSize.h"

@interface Lot ()
@property (nonatomic ,readonly) lot_t lotValue;
@property (nonatomic, readonly) NSNumber *valueObj;
@end

@implementation Lot {
    PositionSize *_positionSize;
    PositionSize *_positionSizeOfLot;
}

- (instancetype)initWithLotValue:(lot_t)lotValue positionSizeOfLot:(PositionSize *)sizeOfLot
{
    PositionSize *positionSize = [[PositionSize alloc] initWithSizeValue:lotValue * sizeOfLot.sizeValue];
    
    return [self initWithPositionSize:positionSize positionSizeOfLot:sizeOfLot];
}

- (instancetype)initWithPositionSize:(PositionSize *)size positionSizeOfLot:(PositionSize *)sizeOfLot
{
    if (self = [super init]) {
        _positionSize = size;
        _positionSizeOfLot = sizeOfLot;
        if (_positionSizeOfLot.sizeValue) {
            _lotValue = _positionSize.sizeValue / _positionSizeOfLot.sizeValue;
        } else {
            DLog(@"sizeOfLot is 0");
        }
    }
    
    return self;
}

- (PositionSize *)toPositionSize
{
    return _positionSize;
}

- (NSString *)stringValue
{
    return self.valueObj.stringValue;
}

- (NSString *)toDisplayString
{
    return [self.valueObj fxs_toDisplayString];
}

- (NSNumber *)valueObj
{
    return [NSNumber numberWithUnsignedLongLong:self.lotValue];
}

@end
