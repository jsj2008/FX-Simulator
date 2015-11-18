//
//  BollingerBandsSource.h
//  FXSimulator
//
//  Created by yuu on 2015/11/18.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "IndicatorSource.h"

@class ChartSource, MovingAverageSource;

@interface BollingerBandsSource : IndicatorSource

@property (nonatomic, retain) id upperLineColor;
@property (nonatomic, retain) id lowerLineColor;
@property (nonatomic) float deviationMultiplier;
@property (nonatomic, retain) MovingAverageSource *movingAverageSource;
@property (nonatomic, retain) ChartSource *chartSource;

@end
