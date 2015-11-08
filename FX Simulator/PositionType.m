//
//  TradeType.m
//  ForexGame
//
//  Created  on 2014/06/23.
//  
//

#import "PositionType.h"

static NSString* const displayBuy = @"Buy";
static NSString* const displaySell = @"Sell";

@implementation PositionType

- (instancetype)init
{
    if (self = [super init]) {
        _isShort = NO;
        _isLong = NO;
    }
    
    return self;
}

- (instancetype)initWithShort
{
    if (self = [super init]) {
        _isShort = YES;
        _isLong = NO;
    }
    
    return self;
}

- (instancetype)initWithLong
{
    if (self = [super init]) {
        _isShort = NO;
        _isLong = YES;
    }
    
    return self;
}

- (instancetype)reverseType
{
    if (self.isShort) {
        return [[[self class] alloc] initWithLong];
    } else if (self.isLong) {
        return [[[self class] alloc] initWithShort];
    }
    
    return nil;
}

- (BOOL)isEqualPositionType:(PositionType *)positionType
{
    if ((self.isLong && positionType.isLong) || (self.isShort && positionType.isShort)) {
        return YES;
    } else {
        return NO;
    }
}

- (NSString *)toDisplayString
{
    if (self.isShort == YES) {
        return displaySell;
    } else if (self.isLong == YES) {
        return displayBuy;
    }
    
    return nil;
}

@end
