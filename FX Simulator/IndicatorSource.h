//
//  IndicatorSource.h
//  FX Simulator
//
//  Created by yuu on 2015/07/13.
//
//

#import <Foundation/Foundation.h>

@class MarketTimeScale;

@interface IndicatorSource : NSObject
- (instancetype)initWithDictionary:(NSDictionary *)dic;
@property (nonatomic, readonly) NSString *indicatorName;
@property (nonatomic, readonly) NSUInteger displayIndex;
@property (nonatomic, readonly) BOOL isMainChart;
@property (nonatomic, readonly) MarketTimeScale *timeScale;
@property (nonatomic, readonly) NSDictionary *sourceDictinary;
+ (NSString *)indicatorNameKey;
@end
