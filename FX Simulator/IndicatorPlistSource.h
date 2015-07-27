//
//  IndicatorSource.h
//  FX Simulator
//
//  Created by yuu on 2015/07/13.
//
//

#import <Foundation/Foundation.h>

@class TimeFrame;

@interface IndicatorPlistSource : NSObject
- (instancetype)initWithIndicatorName:(NSString *)indicatorName displayOrder:(NSUInteger)order;
- (instancetype)initWithDictionary:(NSDictionary *)dic NS_REQUIRES_SUPER;
- (BOOL)isEqualSource:(IndicatorPlistSource *)source NS_REQUIRES_SUPER;
- (NSDictionary *)sourceDictionary NS_REQUIRES_SUPER;
- (BOOL)validateIndicatorSource;
@property (nonatomic, readonly) NSString *indicatorName;
@property (nonatomic, readonly) NSUInteger displayOrder;
+ (NSString *)indicatorNameKey;
+ (NSUInteger)maxIndicatorTerm;
@end
