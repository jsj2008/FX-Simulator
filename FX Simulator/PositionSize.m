//
//  PositionSize.m
//  FX Simulator
//
//  Created  on 2014/12/06.
//  
//

#import "PositionSize.h"

#import "Lot.h"
#import "NSNumber+FXSNumberConverter.h"

static NSString* const FXSPositionSizeKey = @"positionSize";

@implementation PositionSize

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    return [self initWithSizeValue:[aDecoder decodeInt64ForKey:FXSPositionSizeKey]];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInt64:self.sizeValue forKey:FXSPositionSizeKey];
}

- (instancetype)initWithSizeValue:(position_size_t)size
{
    if (self = [super init]) {
        _sizeValue = size;
    }
    
    return self;
}

- (instancetype)initWithNumber:(NSNumber *)number
{
    return [self initWithSizeValue:number.unsignedLongLongValue];
}

- (instancetype)initWithString:(NSString *)string
{
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    
    return [self initWithSizeValue:[formatter numberFromString:string].unsignedLongLongValue];
}

- (NSComparisonResult)comparePositionSize:(PositionSize *)positionSize
{
    return [self.sizeValueObj compare:positionSize.sizeValueObj];
}

- (BOOL)existsPosition
{
    if (0 < self.sizeValue) {
        return YES;
    } else {
        return NO;
    }
}

- (NSString *)toDisplayString
{
    return [self.sizeValueObj fxs_toDisplayString];
}

- (Lot *)toLotFromPositionSizeOfLot:(PositionSize *)sizeOfLot
{
    return [[Lot alloc] initWithPositionSize:self positionSizeOfLot:sizeOfLot];
}

- (BOOL)isEqual:(id)other {
    if (other == self) {
        return YES;
    } else if ([other isKindOfClass:[self class]]) {
        if ([self isEqualPositionSize:other]) {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)isEqualPositionSize:(PositionSize *)positionsize
{
    if (self.sizeValue == positionsize.sizeValue) {
        return YES;
    } else {
        return NO;
    }
}

- (NSNumber *)sizeValueObj
{
    return [NSNumber numberWithUnsignedLongLong:self.sizeValue];
}

@end
