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
- (void)chartScrollViewDidLoad;
- (NSComparisonResult)compareDisplayOrder:(Chart *)chart;
- (void)setChartScrollView:(UIScrollView *)chartScrollView;
- (void)strokeCurrentChart:(Market *)market;
- (void)chartScrollViewDidScroll;
- (ForexHistoryData *)forexDataOfVisibleChartViewPoint:(CGPoint)point;
- (void)scaleStart;
- (void)scaleX:(float)scaleX;
- (void)scaleEnd;

@end
