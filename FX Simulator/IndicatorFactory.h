//
//  IndicatorFactory.h
//  FX Simulator
//
//  Created by yuu on 2015/07/13.
//
//

#import <Foundation/Foundation.h>

@class Indicator;
@class IndicatorSource;

@interface IndicatorFactory : NSObject
+ (Indicator *)createFromSource:(IndicatorSource *)source;
@end
