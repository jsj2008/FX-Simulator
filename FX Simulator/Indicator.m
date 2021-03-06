//
//  Indicator.m
//  FX Simulator
//
//  Created by yuu on 2015/07/13.
//
//

#import "Indicator.h"

#import "IndicatorSource.h"
#import "TimeFrame.h"

@implementation Indicator {
    IndicatorSource *_source;
}

+ (NSUInteger)maxIndicatorPeriod
{
    return 200;
}

- (instancetype)init
{
    return nil;
}

- (instancetype)initWithIndicatorSource:(IndicatorSource *)source
{
    if (self = [super init]) {
        _source = source;
    }
    
    return self;
}

- (void)strokeIndicatorFromForexDataChunk:(ForexDataChunk *)chunk displayDataCount:(NSInteger)count imageSize:(CGSize)imageSize displaySize:(CGSize)displaySize
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

#pragma mark - getter,setter

- (NSUInteger)displayOrder
{
    return _source.displayOrder;
}

- (void)setDisplayOrder:(NSUInteger)displayOrder
{
    _source.displayOrder = displayOrder;
}

@end
