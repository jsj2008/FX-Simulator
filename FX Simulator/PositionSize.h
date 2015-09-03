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
- (instancetype)initWithSizeValue:(position_size_t)size;
- (BOOL)existsPosition;
- (NSString *)toDisplayString;
- (Lot *)toLot;
- (BOOL)isEqualPositionSize:(PositionSize *)positionsize;
@property (nonatomic, readonly) position_size_t sizeValue;
@property (nonatomic, readonly) NSNumber *sizeValueObj;
@end
