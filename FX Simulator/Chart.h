//
//  Chart.h
//  FX Simulator
//
//  Created by yuu on 2015/07/18.
//
//

#import <Foundation/Foundation.h>

@class ChartSource;
@class ForexDataChunk;

@interface Chart : NSObject
- (instancetype)initWithChartSource:(ChartSource *)source;
- (void)setForexDataChunk:(ForexDataChunk *)chunk;
- (void)stroke;
- (BOOL)isEqualChartIndex:(NSUInteger)index;
@property (nonatomic, readonly) NSDictionary *chartSourceDictionary;
@end
