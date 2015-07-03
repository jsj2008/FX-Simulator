//
//  Lot.m
//  FX Simulator
//
//  Created  on 2014/12/04.
//  
//

#import "Lot.h"

#import "NSNumber+FXSNumberConverter.h"
#import "SaveLoader.h"
#import "SaveData.h"
#import "PositionSize.h"

@implementation Lot

-(id)initWithLotValue:(lot_t)value
{
    if (self = [super init]) {
        _lotValue = value;
    }
    
    return self;
}

-(PositionSize*)toPositionSize
{
    SaveData *saveData = [SaveLoader load];
    
    position_size_t size = self.lotValue * saveData.positionSizeOfLot.sizeValue;
    
    return [[PositionSize alloc] initWithSizeValue:size];
}

-(NSString*)toDisplayString
{
    return [self.valueObj fxs_toDisplayString];
    //return [NSString stringWithFormat:@"%llu", self.lotValue];
}

-(NSNumber*)valueObj
{
    return [NSNumber numberWithUnsignedLongLong:self.lotValue];
}

/*-(NSString*)stringValue
{
    return [NSString stringWithFormat:@"%llu", self.lotValue];
}*/

@end
