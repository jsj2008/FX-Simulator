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
@property (nonatomic ,readonly) lot_t lotValue;
@property (nonatomic, readonly) NSNumber *valueObj;
- (instancetype)initWithLotValue:(lot_t)value;
- (PositionSize *)toPositionSize;
- (NSString *)toDisplayString;
@end
