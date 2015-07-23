//
//  Indicator.m
//  FX Simulator
//
//  Created by yuu on 2015/07/13.
//
//

#import "Indicator.h"

#import "IndicatorPlistSource.h"
#import "MarketTimeScale.h"

@implementation Indicator {
    IndicatorPlistSource *_source;
}

- (instancetype)init
{
    return nil;
}

- (instancetype)initWithSource:(IndicatorPlistSource *)source
{
    if (self = [super init]) {
        _source = source;
    }
    
    return self;
}

- (NSUInteger)displayOrder
{
    return _source.displayOrder;
}

- (void)strokeIndicatorFromForexDataChunk:(ForexDataChunk *)chunk displayForexDataCount:(NSInteger)count displaySize:(CGSize)size
{
    return;
}

- (NSComparisonResult)compareDisplayOrder:(Indicator *)indicator
{
    if (_source.displayOrder < indicator.displayOrder) {
        return NSOrderedAscending;
    } else if (_source.displayOrder > indicator.displayOrder) {
        return NSOrderedDescending;
    } else {
        return NSOrderedSame;
    }
}

- (NSDictionary *)sourceDictionary
{
    return nil;
}

@end