//
//  Lot.h
//  FX Simulator
//
//  Created  on 2014/12/04.
//  
//

#import "Common.h"

@class PositionSize;

@interface Lot : NSObject
@property (nonatomic, readonly) NSString *stringValue;
- (instancetype)initWithLotValue:(lot_t)lotValue positionSizeOfLot:(PositionSize *)sizeOfLot;
- (instancetype)initWithPositionSize:(PositionSize *)size positionSizeOfLot:(PositionSize *)sizeOfLot;
- (PositionSize *)toPositionSize;
- (NSString *)toDisplayString;
@end
