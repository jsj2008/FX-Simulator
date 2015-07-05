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

/*@protocol Candle <NSObject>
@property (nonatomic) CGRect rect;
@property (nonatomic) CGPoint highLineTop;
@property (nonatomic) CGPoint highLineBottom;
@property (nonatomic) CGPoint lowLineTop;
@property (nonatomic) CGPoint lowLineBottom;
@property (nonatomic) float colorR;
@property (nonatomic) float colorG;
@property (nonatomic) float colorB;
@property (nonatomic) id<ForexHistoryData> forexHistoryData;
@end*/

@interface Candle : NSObject
-(void)stroke;
@property (nonatomic) CGRect rect;
@property (nonatomic) CGPoint highLineTop;
@property (nonatomic) CGPoint highLineBottom;
@property (nonatomic) CGPoint lowLineTop;
@property (nonatomic) CGPoint lowLineBottom;
@property (nonatomic) float colorR;
@property (nonatomic) float colorG;
@property (nonatomic) float colorB;
@property (nonatomic) ForexHistoryData *forexHistoryData;
@end
