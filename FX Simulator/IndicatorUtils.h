//
//  TechnicalUtils.h
//  FX Simulator
//
//  Created by yuu on 2015/07/04.
//
//

#import <Foundation/Foundation.h>

@import UIKit;

@class Rate;

@interface IndicatorUtils : NSObject
/**
 @param num そのレートポイントが何番目に表示されるのか(0から始まる)。
 @param count レートポイントが表示される個数。
 @param size 表示するViewのサイズ。
*/
+(CGPoint)getChartViewPointFromRate:(Rate*)rate ratePointNumber:(NSInteger)num minRate:(Rate*)minRate maxRate:(Rate*)maxRate ratePointCount:(NSInteger)count viewSize:(CGSize)size;
@end
