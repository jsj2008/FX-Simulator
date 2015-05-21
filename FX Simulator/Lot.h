//
//  Lot.h
//  FX Simulator
//
//  Created  on 2014/12/04.
//  
//

//#import <Foundation/Foundation.h>
#import "Common.h"

@class PositionSize;

@interface Lot : NSObject
-(id)initWithLotValue:(lot_t)value;
-(PositionSize*)toPositionSize;
-(NSString*)toDisplayString;
@property (nonatomic ,readonly) lot_t lotValue;
@property (nonatomic, readonly) NSNumber *valueObj;
@end
