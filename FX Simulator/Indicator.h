//
//  Indicator.h
//  FX Simulator
//
//  Created by yuu on 2015/07/05.
//
//

#import <Foundation/Foundation.h>
#import "IndicatorPlistSource.h"

@import UIKit;

@class UIBezierPath;
@class UIView;
@class ForexDataChunk;
@class TimeFrame;

/**
 @param count 画面に表示するForexDataの個数。
*/

@interface Indicator : NSObject
- (instancetype)initWithSource:(IndicatorPlistSource *)source NS_REQUIRES_SUPER;
- (void)strokeIndicatorFromForexDataChunk:(ForexDataChunk *)chunk displayForexDataCount:(NSInteger)count displaySize:(CGSize)size;
- (NSComparisonResult)compareDisplayOrder:(Indicator *)indicator;
- (NSDictionary *)sourceDictionary;
@property (nonatomic, readonly) NSUInteger displayOrder;
@end

