//
//  TradeType.m
//  ForexGame
//
//  Created  on 2014/06/23.
//  
//

#import "OrderType.h"

static NSString* const buy = @"BUY";
static NSString* const sell = @"SELL";
static NSString* const displayBuy = @"Buy";
static NSString* const displaySell = @"Sell";

@implementation OrderType {
    NSString *type;
}

-(id)init
{
    if (self = [super init]) {
        _isShort = NO;
        _isLong = NO;
    }
    
    return self;
}

-(instancetype)initWithShort
{
    if (self = [super init]) {
        _isShort = YES;
        _isLong = NO;
    }
    
    return self;
}

-(instancetype)initWithLong
{
    if (self = [super init]) {
        _isShort = NO;
        _isLong = YES;
    }
    
    return self;
}

-(id)initWithString:(NSString *)typeString
{
    if (self = [self init]) {
        if ([sell isEqualToString:typeString]) {
            _isShort = YES;
        } else if ([buy isEqualToString:typeString]) {
            _isLong = YES;
        } else {
            return nil;
        }
    }
    
    return self;
}

-(void)setShort
{
    _isShort = YES;
}

-(void)setLong
{
    _isLong = YES;
}

-(BOOL)isEqualOrderType:(OrderType *)orderType
{
    if ((self.isLong && orderType.isLong) || (self.isShort && orderType.isShort)) {
        return YES;
    } else {
        return NO;
    }
}

-(NSString*)toDisplayString
{
    if (self.isShort == YES) {
        return displaySell;
    } else if (self.isLong == YES) {
        return displayBuy;
    }
    
    return nil;
}

-(NSString*)toTypeString
{
    if (self.isShort == YES) {
        return sell;
    } else if (self.isLong == YES) {
        return buy;
    }
    
    return nil;
}


-(UIColor*)toColor
{
    if (self.isShort) {
        return [UIColor redColor];
    } else if (self.isLong) {
        return [UIColor blueColor];
    }
    
    return nil;
}

@end
