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
- (instancetype)initWithIndicatorName:(NSString *)indicatorName displayOrder:(NSUInteger)order;
- (instancetype)initWithDictionary:(NSDictionary *)dic NS_REQUIRES_SUPER;
- (BOOL)isEqualSource:(IndicatorSource *)source NS_REQUIRES_SUPER;
- (NSDictionary *)sourceDictionary NS_REQUIRES_SUPER;
- (BOOL)validateIndicatorSource;
@property (nonatomic, readonly) NSString *indicatorName;
@property (nonatomic, readonly) NSUInteger displayOrder;
+ (NSString *)indicatorNameKey;
+ (NSUInteger)maxIndicatorTerm;
@end
