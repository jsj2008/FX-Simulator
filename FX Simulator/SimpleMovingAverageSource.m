//
//  SimpleMovingAverageSource.m
//  FX Simulator
//
//  Created by yuu on 2015/07/13.
//
//

#import "SimpleMovingAverageSource.h"

#import "MarketTimeScale.h"
#import "SimpleMovingAverage.h"

static NSString* const kTermKey = @"Term";
static NSString* const kLineColorDataKey = @"LineColorData";

@implementation SimpleMovingAverageSource {
    NSString *_codeName;
}

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    if (self = [super initWithDictionary:dic]) {
        if (![_codeName isEqualToString:[SimpleMovingAverage indicatorName]]) {
            return nil;
        }
        _term = ((NSNumber *)[dic objectForKey:kTermKey]).unsignedIntegerValue;
        NSData *lineColorData = [dic objectForKey:kLineColorDataKey];
        _lineColor = [NSKeyedUnarchiver unarchiveObjectWithData:lineColorData];
    }
    
    return self;
}

- (NSDictionary *)sourceDictinary
{
    NSMutableDictionary *dic = [[super sourceDictinary] mutableCopy];
    
    [dic setObject:@(self.term) forKey:kTermKey];
    
    if (self.lineColor != nil) {
        NSData *lineColorData = [NSKeyedArchiver archivedDataWithRootObject:self.lineColor];
        [dic setObject:lineColorData forKey:kLineColorDataKey];
    }
    
    return [dic copy];
}

@end
