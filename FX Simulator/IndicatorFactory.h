//
//  IndicatorFactory.h
//  FX Simulator
//
//  Created by yuu on 2015/07/13.
//
//

#import <Foundation/Foundation.h>

@protocol Indicator;
@protocol IndicatorSource;

@interface IndicatorFactory : NSObject
+ (id<Indicator>)createFromSource:(id<IndicatorSource>)source;
@end
