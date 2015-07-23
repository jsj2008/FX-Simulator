//
//  IndicatorSourceFactory.h
//  FX Simulator
//
//  Created by yuu on 2015/07/13.
//
//

#import <Foundation/Foundation.h>

@class IndicatorPlistSource;

@interface IndicatorSourceFactory : NSObject
+ (IndicatorPlistSource *)createFrom:(NSDictionary *)dic;
@end
