//
//  IndicatorSource.m
//  FX Simulator
//
//  Created by yuu on 2015/07/13.
//
//

#import "IndicatorPlistSource.h"

#import "TimeFrame.h"

static const NSUInteger kMaxIndicatorTerm = 200;
static NSString* const kIndicatorNameKey = @"IndicatorName";
static NSString* const kDisplayOrderKey = @"DisplayOrder";


@implementation IndicatorPlistSource

- (instancetype)initWithIndicatorName:(NSString *)indicatorName displayOrder:(NSUInteger)order
{
    if (self = [super init]) {
        _indicatorName = indicatorName;
        _displayOrder = order;
    }
    
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    return [self initWithIndicatorName:dic[kIndicatorNameKey] displayOrder:((NSNumber *)dic[kDisplayOrderKey]).unsignedIntegerValue];
}

- (BOOL)isEqualSource:(IndicatorPlistSource *)source
{
    if ([self.indicatorName isEqualToString:source.indicatorName] && self.displayOrder == source.displayOrder) {
        return YES;
    }
    
    return NO;
}

- (NSDictionary *)sourceDictinary
{
    NSMutableDictionary *sourceDictionary = [NSMutableDictionary dictionary];
    
    if (self.indicatorName) {
        sourceDictionary[kIndicatorNameKey] = self.indicatorName;
    }
    
    sourceDictionary[kDisplayOrderKey] = @(self.displayOrder);
    
    return [sourceDictionary copy];
}

+ (NSString *)indicatorNameKey
{
    return kIndicatorNameKey;
}

+ (NSUInteger)maxIndicatorTerm
{
    return kMaxIndicatorTerm;
}

@end
