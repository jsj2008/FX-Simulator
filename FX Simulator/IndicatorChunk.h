//
//  IndicatorChunk.h
//  FX Simulator
//
//  Created by yuu on 2015/07/13.
//
//

#import <Foundation/Foundation.h>

@protocol Indicator;

@class MarketTimeScale;

@interface IndicatorChunk : NSObject
- (instancetype)initWithIndicatorArray:(NSArray *)array;

/**
 インジケーターを表示順に列挙。
*/
- (void)enumerateIndicatorsUsingBlock:(void (^)(id<Indicator> indicator))block isMainChart:(BOOL)isMainChart timeScale:(MarketTimeScale *)timeScale;



@end
