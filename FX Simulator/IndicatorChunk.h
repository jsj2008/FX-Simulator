//
//  IndicatorChunk.h
//  FX Simulator
//
//  Created by yuu on 2015/07/13.
//
//

#import <Foundation/Foundation.h>


@class Indicator;
@class TimeFrame;

@interface IndicatorChunk : NSObject
- (instancetype)initWithIndicatorArray:(NSArray *)indicatorArray;

/**
 インジケーターを表示順に列挙。
*/
- (void)enumerateIndicatorsUsingBlock:(void (^) (Indicator *indicator))block;

@property (nonatomic, readonly) NSArray *indicatorSourceDictionaryArray;

@end
