//
//  Chart.h
//  ForexGame
//
//  Created  on 2014/04/03.
//  
//

@import UIKit;

@class Chart;
@class ForexDataChunk;

@interface ChartView : UIView

/**
 描写するチャートをセットする。
*/
@property (nonatomic) Chart *chart;

/**
 チャートを描写するために使うForexDataChunk
*/
@property (nonatomic) ForexDataChunk *forexDataChunk;

@end
