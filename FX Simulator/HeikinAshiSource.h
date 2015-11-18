//
//  HeikinAshiSource.h
//  FXSimulator
//
//  Created by yuu on 2015/11/18.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CandleBaseSource.h"

@class ChartSource, MovingAverageSource;

@interface HeikinAshiSource : CandleBaseSource

@property (nonatomic, retain) MovingAverageSource *movingAverageSource;
@property (nonatomic, retain) ChartSource *chartSource;

@end
