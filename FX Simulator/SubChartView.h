//
//  SubChartView.h
//  FX Simulator
//
//  Created  on 2014/11/14.
//  
//

#import <UIKit/UIKit.h>

@class ForexDataChunk;

@interface SubChartView : UIView
@property (nonatomic) NSUInteger displayForexDataCount;
@property (nonatomic) ForexDataChunk *chunk;
@end
