//
//  MovingAverageSource.h
//  FXSimulator
//
//  Created by yuu on 2015/11/18.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "IndicatorSource.h"

@class BollingerBandsSource, ChartSource, HeikinAshiSource;

@interface MovingAverageSource : IndicatorSource

@property (nonatomic, retain) id lineColor;
@property (nonatomic) int32_t period;
@property (nonatomic, retain) id type;
@property (nonatomic, retain) ChartSource *chartSource;
@property (nonatomic, retain) BollingerBandsSource *bollingerBandsSource;
@property (nonatomic, retain) HeikinAshiSource *heikinAshiSource;

@end
