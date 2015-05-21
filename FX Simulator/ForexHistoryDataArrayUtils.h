//
//  CandlesUtils.h
//  FX Simulator
//
//  Created  on 2014/10/30.
//  
//

#import <Foundation/Foundation.h>

@class Rate;

@interface ForexHistoryDataArrayUtils : NSObject
+(double)maxRateOfArray:(NSArray*)array;
+(double)minRateOfArray:(NSArray*)array;
@end
