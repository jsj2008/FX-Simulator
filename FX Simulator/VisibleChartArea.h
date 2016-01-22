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
@class ForexHistoryData;

@interface VisibleChartArea : NSObject
@property (nonatomic) EntityChart *currentEntityChart;
@property (nonatomic, readonly) NSUInteger displayDataCount;
- (instancetype)initWithChartScrollView:(UIScrollView *)chartScrollView entityChartView:(UIImageView *)entityChartView displayDataCount:(NSUInteger)displayDataCount;
- (void)chartScrollViewDidLoad;
- (void)chartScrollViewDidScroll;
- (void)scaleStart;
- (void)scaleX:(float)scaleX;
- (void)scaleEnd;
- (BOOL)isInPreparePreviousChartRange;
- (BOOL)isInPrepareNextChartRange;
- (BOOL)isOverLeftEnd;
- (BOOL)isOverRightEnd;
- (ForexHistoryData *)forexDataOfVisibleChartViewPoint:(CGPoint)point;
- (void)visibleForRightEndOfEntityChart;
- (void)visibleForStartXOfEntityChart:(float)startX;
- (void)visibleForEndXOfEntityChart:(float)endX;
- (void)visibleForStartXOfEntityChart:(float)startX endXOfEntityChart:(float)endX;
@end
