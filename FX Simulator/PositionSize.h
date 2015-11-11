//
//  PositionSize.h
//  FX Simulator
//
//  Created  on 2014/12/06.
//  
//

#import <Foundation/Foundation.h>
#import "Common.h"

@class Lot;

@interface PositionSize : NSObject <NSCoding>
@property (nonatomic, readonly) position_size_t sizeValue;
@property (nonatomic, readonly) NSNumber *sizeValueObj;
- (instancetype)initWithSizeValue:(position_size_t)size;
- (instancetype)initWithNumber:(NSNumber *)number;
- (instancetype)initWithString:(NSString *)string;
- (NSComparisonResult)comparePositionSize:(PositionSize *)positionSize;
- (BOOL)existsPosition;
- (NSString *)toDisplayString;
- (Lot *)toLotFromPositionSizeOfLot:(PositionSize *)sizeOfLot;
- (BOOL)isEqualPositionSize:(PositionSize *)positionsize;
@end
