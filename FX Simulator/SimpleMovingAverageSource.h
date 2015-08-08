//
//  SimpleMovingAverageSource.h
//  FXSimulator
//
//  Created by yuu on 2015/07/27.
//
//

#import "IndicatorSource.h"

@class NSManagedObject;

@interface SimpleMovingAverageSource : IndicatorSource

@property (nonatomic, retain) id lineColor;
@property (nonatomic) int32_t period;
@property (nonatomic, retain) NSManagedObject *chartSource;

@end
