//
//  CandleChartSource.h
//  FX Simulator
//
//  Created by yuu on 2015/07/17.
//
//

#import "IndicatorSource.h"

@import UIKit;

@interface CandleSource : IndicatorSource
- (instancetype)initWithDefault;
- (BOOL)isEqualSource:(CandleSource *)source;
@property (nonatomic) UIColor *upColor;
@property (nonatomic) UIColor *downColor;
@property (nonatomic) UIColor *upFrameColor;
@property (nonatomic) UIColor *downFrameColor;
@property (nonatomic) UIColor *upLineColor;
@property (nonatomic) UIColor *downLineColor;
+ (NSString *)indicatorName;
@end
