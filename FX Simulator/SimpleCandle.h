//
//  Candle.h
//  FX Simulator
//
//  Created  on 2014/10/30.
//  
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class ForexHistoryData;

@interface SimpleCandle : NSObject
@property (nonatomic) CGRect areaRect;
@property (nonatomic) CGRect rect;
@property (nonatomic) CGPoint highLineTop;
@property (nonatomic) CGPoint highLineBottom;
@property (nonatomic) CGPoint lowLineTop;
@property (nonatomic) CGPoint lowLineBottom;
@property (nonatomic) UIColor *color;
@property (nonatomic) UIColor *lineColor;
@property (nonatomic) ForexHistoryData *forexHistoryData;
- (void)stroke;
@end
