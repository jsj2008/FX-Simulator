//
//  Chart.h
//  FX Simulator
//
//  Created by yuu on 2015/07/18.
//
//

#import <Foundation/Foundation.h>

@import UIKit;

@class SaveDataSource;
@class CurrencyPair;
@class TimeFrame;
@class VisibleChartView;
@class ChartSource;
@class VisibleChartView;
@class ForexDataChunk;
@class ForexHistoryData;
@class Market;
@class IndicatorChunk;

@interface Chart : NSObject

@property (nonatomic, readonly) ChartSource *chartSource;
@property (nonatomic) NSUInteger chartIndex;
@property (nonatomic) CurrencyPair *currencyPair;
@property (nonatomic) BOOL isDisplay;
@property (nonatomic) TimeFrame *timeFrame;
@property (nonatomic) NSUInteger displayDataCount;
@property (nonatomic) IndicatorChunk *indicatorChunk;

+ (instancetype)createNewMainChartFromSaveDataSource:(SaveDataSource *)source;
+ (instancetype)createNewSubChartFromSaveDataSource:(SaveDataSource *)source;
+ (instancetype)createChartFromChartSource:(ChartSource *)source;
- (NSComparisonResult)compareDisplayOrder:(Chart *)chart;
- (ForexHistoryData *)getForexDataFromTouchPoint:(CGPoint)point displayCount:(NSUInteger)count viewSize:(CGSize)size;
- (void)setVisibleChartView:(UIView *)visibleView;
- (void)strokeCurrentChart:(Market *)market;
- (void)didChangeEntityChartViewPositionX;
- (void)scaleStart;
- (void)scaleX:(float)scaleX;
- (void)scaleEnd;

/**
 短時間に何度も呼ばれるので、軽くしておく。
*/
- (void)translate:(float)tx;

- (void)animateTranslation:(float)tx duration:(float)duration;
- (void)removeAnimation;

@end
