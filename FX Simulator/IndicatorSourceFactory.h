//
//  IndicatorSourceFactory.h
//  FX Simulator
//
//  Created by yuu on 2015/07/13.
//
//

#import <Foundation/Foundation.h>

@class IndicatorSource;

@interface IndicatorSourceFactory : NSObject
+ (IndicatorSource *)createFrom:(NSDictionary *)dic;
@end
