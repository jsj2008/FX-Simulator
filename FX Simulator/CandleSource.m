//
//  CandleChartSource.m
//  FX Simulator
//
//  Created by yuu on 2015/07/17.
//
//

#import "CandleSource.h"

static NSString* const FXSUpColorDataKey = @"UpColorData";
static NSString* const FXSDownColorDataKey = @"DownColorData";
static NSString* const FXSUpFrameColorDataKey = @"UpFrameColorData";
static NSString* const FXSDownFrameColorDataKey = @"DownFrameColorData";
static NSString* const FXSUpLineColorDataKey = @"UpLineColorData";
static NSString* const FXSDownLineColorDataKey = @"DownLineColorData";

@implementation CandleSource

@synthesize indicatorName = _indicatorName;
@synthesize displayOrder = _displayOrder;

- (instancetype)initWithDefault
{
    if (self = [super initWithIndicatorName:[CandleSource indicatorName] displayOrder:0]) {
        UIColor *upColor = [UIColor colorWithRed:35.0/255.0 green:172.0/255.0 blue:14.0/255.0 alpha:1.0];
        UIColor *downColor = [UIColor colorWithRed:199.0/250.0 green:36.0/255.0 blue:58.0/255.0 alpha:1.0];
        _upColor = upColor;
        _downColor = downColor;
        _upFrameColor = upColor;
        _downFrameColor = downColor;
        _upLineColor = upColor;
        _downColor = downColor;
    }
    
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    if (self = [super initWithDictionary:dic]) {
        if (![super.indicatorName isEqualToString:[[self class] indicatorName]]) {
            return nil;
        }
        NSData *upColorData = [dic objectForKey:FXSUpColorDataKey];
        _upColor = [NSKeyedUnarchiver unarchiveObjectWithData:upColorData];
        NSData *downColorData = [dic objectForKey:FXSDownColorDataKey];
        _downColor = [NSKeyedUnarchiver unarchiveObjectWithData:downColorData];
        
        NSData *upFrameColorData = [dic objectForKey:FXSUpFrameColorDataKey];
        _upFrameColor = [NSKeyedUnarchiver unarchiveObjectWithData:upFrameColorData];
        NSData *downFrameColorData = [dic objectForKey:FXSDownFrameColorDataKey];
        _downFrameColor = [NSKeyedUnarchiver unarchiveObjectWithData:downFrameColorData];
        
        NSData *upLineColorData = [dic objectForKey:FXSUpLineColorDataKey];
        _upLineColor = [NSKeyedUnarchiver unarchiveObjectWithData:upLineColorData];
        NSData *downLineColorData = [dic objectForKey:FXSDownLineColorDataKey];
        _downLineColor = [NSKeyedUnarchiver unarchiveObjectWithData:downLineColorData];
    }
    
    return self;
}

- (BOOL)isEqualSource:(CandleSource *)source
{
    if (![super isEqualSource:source]) {
        return NO;
    }
    
    BOOL resultUpColor = [_upColor isEqual:source.upColor];
    BOOL resultDownColor = [_downColor isEqual:source.downColor];
    BOOL resultUpFrameColor = [_upFrameColor isEqual:source.upFrameColor];
    BOOL resultDownFrameColor = [_downFrameColor isEqual:source.downFrameColor];
    BOOL resultUpLineClor = [_upLineColor isEqual:source.upLineColor];
    BOOL resultDownLineColor = [_downLineColor isEqual:source.downLineColor];
    
    if ( resultUpColor && resultDownColor && resultUpFrameColor && resultDownFrameColor && resultUpLineClor && resultDownLineColor) {
        return YES;
    }
    
    return NO;
}

- (NSDictionary *)sourceDictionary
{
    NSMutableDictionary *dic = [[super sourceDictionary] mutableCopy];
    
    if (self.upColor) {
        NSData *upColorData = [NSKeyedArchiver archivedDataWithRootObject:self.upColor];
        [dic setObject:upColorData forKey:FXSUpColorDataKey];
    }
    
    if (self.downColor) {
        NSData *downColorData = [NSKeyedArchiver archivedDataWithRootObject:self.downColor];
        [dic setObject:downColorData forKey:FXSDownColorDataKey];
    }
    
    if (self.upFrameColor) {
        NSData *upFrameColorData = [NSKeyedArchiver archivedDataWithRootObject:self.upFrameColor];
        [dic setObject:upFrameColorData forKey:FXSUpFrameColorDataKey];
    }
    
    if (self.downFrameColor) {
        NSData *downFrameColorData = [NSKeyedArchiver archivedDataWithRootObject:self.downFrameColor];
        [dic setObject:downFrameColorData forKey:FXSDownFrameColorDataKey];
    }
    
    if (self.upLineColor) {
        NSData *upLineColorData = [NSKeyedArchiver archivedDataWithRootObject:self.upLineColor];
        [dic setObject:upLineColorData forKey:FXSUpLineColorDataKey];
    }
    
    if (self.downLineColor) {
        NSData *downLineColorData = [NSKeyedArchiver archivedDataWithRootObject:self.downLineColor];
        [dic setObject:downLineColorData forKey:FXSDownLineColorDataKey];
    }
    
    return [dic copy];
}

+ (NSString *)indicatorName
{
    return @"CandleChart";
}

@end
