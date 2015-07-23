//
//  CandleChartSource.h
//  FX Simulator
//
//  Created by yuu on 2015/07/17.
//
//

#import "IndicatorPlistSource.h"

@import UIKit;

@interface CandlePlistSource : IndicatorPlistSource
- (instancetype)initWithDefault;
- (BOOL)isEqualSource:(CandlePlistSource *)source;
@property (nonatomic) UIColor *upColor;
@property (nonatomic) UIColor *downColor;
@property (nonatomic) UIColor *upFrameColor;
@property (nonatomic) UIColor *downFrameColor;
@property (nonatomic) UIColor *upLineColor;
@property (nonatomic) UIColor *downLineColor;
+ (NSString *)indicatorName;
@end
