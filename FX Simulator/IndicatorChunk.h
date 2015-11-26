//
//  IndicatorChunk.h
//  FX Simulator
//
//  Created by yuu on 2015/07/13.
//
//

#import <Foundation/Foundation.h>

@import UIKit;

@class Indicator;
@class TimeFrame;
@class ForexDataChunk;

@interface IndicatorChunk : NSObject
- (instancetype)initWithIndicatorArray:(NSArray *)indicatorArray;

/**
 インジケーターを表示順に列挙。
*/
- (void)enumerateIndicatorsUsingBlock:(void (^) (Indicator *indicator))block;

/**
 そのチャートのベースとなるような(Candleなど)Indicatorが存在するか。
*/
- (BOOL)existsBaseIndicator;

- (void)strokeIndicatorFromForexDataChunk:(ForexDataChunk *)chunk displayDataCount:(NSInteger)count imageSize:(CGSize)imageSize displaySize:(CGSize)displaySize;

@end
