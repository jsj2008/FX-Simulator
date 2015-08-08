//
//  CandleSource.h
//  FXSimulator
//
//  Created by yuu on 2015/07/27.
//
//

#import "IndicatorSource.h"

@class NSManagedObject;

@interface CandleSource : IndicatorSource

@property (nonatomic, retain) id downColor;
@property (nonatomic, retain) id downLineColor;
@property (nonatomic, retain) id upColor;
@property (nonatomic, retain) id upLineColor;
@property (nonatomic, retain) NSManagedObject *chartSource;

@end
