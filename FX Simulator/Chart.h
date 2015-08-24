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
@class ChartSource;
@class ForexDataChunk;
@class ForexHistoryData;
@class IndicatorChunk;

@interface Chart : NSObject
+ (instancetype)createNewMainChartFromSaveDataSource:(SaveDataSource *)source;
+ (instancetype)createNewSubChartFromSaveDataSource:(SaveDataSource *)source;
+ (instancetype)createChartFromChartSource:(ChartSource *)source;
- (NSComparisonResult)compareDisplayOrder:(Chart *)chart;
- (void)strokeFromForexDataChunk:(ForexDataChunk *)chunk viewSize:(CGSize)size;
- (BOOL)isEqualChartIndex:(NSUInteger)index;
- (ForexHistoryData *)getForexDataFromTouchPoint:(CGPoint)point displayCount:(NSUInteger)count viewSize:(CGSize)size;
@property (nonatomic, readonly) ChartSource *chartSource;
@property (nonatomic) NSUInteger chartIndex;
@property (nonatomic) CurrencyPair *currencyPair;
@property (nonatomic) BOOL isSelected;
@property (nonatomic) TimeFrame *timeFrame;
@property (nonatomic) NSUInteger displayDataCount;
@property (nonatomic) IndicatorChunk *indicatorChunk;
@end
