//
//  Indicator.h
//  FX Simulator
//
//  Created by yuu on 2015/07/05.
//
//

#import <Foundation/Foundation.h>

@import UIKit;

@class UIBezierPath;
@class UIView;
@class ForexDataChunk;

/**
 @param count 画面に表示するForexDataの個数。
*/

@protocol Indicator <NSObject>
- (void)strokeIndicatorFromForexDataChunk:(ForexDataChunk *)chunk displayForexDataCount:(NSInteger)count displaySize:(CGSize)size;
@end

