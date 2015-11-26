//
//  CandlesFactory.h
//  FX Simulator
//
//  Created  on 2014/10/30.
//  
//

#import <Foundation/Foundation.h>

@import UIKit;

@class ForexDataChunk;

@interface CandlesFactory : NSObject
+ (NSArray *)createCandlesFromForexHistoryDataChunk:(ForexDataChunk *)chunk displayForexDataCount:(NSInteger)count chartSize:(CGSize)chartSize upColor:(UIColor *)upColor upLineColor:(UIColor *)upLineColor downColor:(UIColor *)downColor downLineColor:(UIColor *)downLineColor;
@end
