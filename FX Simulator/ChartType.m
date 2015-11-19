//
//  ChartType.m
//  FXSimulator
//
//  Created by yuu on 2015/11/18.
//
//

#import "ChartType.h"

@interface ChartType ()
@property (nonatomic, readonly) NSString *typeCode;
@end

static NSString* const FXSChartTypeKey = @"ChartType";
static NSString* const FXSChartTypeMain = @"MainChart";
static NSString* const FXSChartTypeSub = @"SubChart";

@implementation ChartType

+ (instancetype)mainChart
{
    return [[[self class] alloc] initWithChartTypeCode:FXSChartTypeMain];
}

+ (instancetype)subChart
{
    return [[[self class] alloc] initWithChartTypeCode:FXSChartTypeSub];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    NSString *typeCode = [aDecoder decodeObjectForKey:FXSChartTypeKey];
    
    return [self initWithChartTypeCode:typeCode];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.typeCode forKey:FXSChartTypeKey];
}

- (instancetype)initWithChartTypeCode:(NSString *)typeCode
{
    if (!typeCode) {
        return nil;
    }
    
    if (self = [super init]) {
        _typeCode = typeCode;
    }
    
    return self;
}

- (BOOL)isMainChart
{
    if ([self.typeCode isEqualToString:FXSChartTypeMain]) {
        return YES;
    }
    
    return NO;
}

- (BOOL)isSubChart
{
    if ([self.typeCode isEqualToString:FXSChartTypeSub]) {
        return YES;
    }
    
    return NO;
}

@end
