//
//  PositionSize.m
//  FX Simulator
//
//  Created  on 2014/12/06.
//  
//

#import "PositionSize.h"

#import "NSNumber+FXSNumberConverter.h"
#import "SaveLoader.h"
#import "SaveData.h"
#import "Lot.h"


@implementation PositionSize

-(id)initWithSizeValue:(position_size_t)size
{
    if (self = [super init]) {
        _sizeValue = size;
    }
    
    return self;
}

-(NSString*)toDisplayString
{
    return [self.sizeValueObj fxs_toDisplayString];
}

-(Lot*)toLot
{
    SaveData *saveData = [SaveLoader load];
    
    lot_t lotValue = self.sizeValue / saveData.positionSizeOfLot.sizeValue;
    
    return [[Lot alloc] initWithLotValue:lotValue];
}

-(BOOL)isEqualPositionSize:(PositionSize *)positionsize
{
    if (self.sizeValue == positionsize.sizeValue) {
        return YES;
    } else {
        return NO;
    }
}

-(NSNumber*)sizeValueObj
{
    return [NSNumber numberWithUnsignedLongLong:self.sizeValue];
}

@end
