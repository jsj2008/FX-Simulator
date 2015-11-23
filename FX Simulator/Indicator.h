//
//  Indicator.h
//  FX Simulator
//
//  Created by yuu on 2015/07/05.
//
//

#import <Foundation/Foundation.h>
#import "IndicatorSource.h"

@import UIKit;

@class UIBezierPath;
@class UIView;
@class ForexDataChunk;
@class TimeFrame;

@interface Indicator : NSObject
+ (NSUInteger)maxIndicatorPeriod;
- (instancetype)initWithIndicatorSource:(IndicatorSource *)source;

/**
 @param count 画面に表示するForexDataの個数。
*/
- (void)strokeIndicatorFromForexDataChunk:(ForexDataChunk *)chunk displayDataCount:(NSInteger)count imageSize:(CGSize)imageSize displaySize:(CGSize)displaySize;

- (NSComparisonResult)compareDisplayOrder:(Indicator *)indicator;
@property (nonatomic) NSUInteger displayOrder;
@end

