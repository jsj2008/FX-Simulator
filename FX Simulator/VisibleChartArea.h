//
//  VisibleChartArea.h
//  FXSimulator
//
//  Created by yuu on 2015/10/18.
//
//

#import <Foundation/Foundation.h>

@import UIKit;

@class EntityChart;

@interface VisibleChartArea : NSObject
@property (nonatomic) EntityChart *currentEntityChart;
- (instancetype)initWithVisibleChartView:(UIView *)visibleChartView entityChartView:(UIImageView *)entityChartView;
- (BOOL)isInPreparePreviousChartRange;
- (BOOL)isInPrepareNextChartRange;
- (BOOL)isOverLeftEnd;
- (BOOL)isOverRightEnd;
- (BOOL)isOverMoveRangeLeftEnd;
- (BOOL)isOverMoveRangeRightEnd;
- (void)setLeftEnd;
- (void)setRightEnd;
- (void)setMoveRangeLeftEnd;
- (void)setMoveRangeRightEnd;
- (void)visibleForStartXOfEntityChart:(float)startX endXOfEntityChart:(float)endX inAnimation:(BOOL)inAnimation;
@end
