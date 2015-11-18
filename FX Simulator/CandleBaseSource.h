//
//  CandleBaseSource.h
//  FXSimulator
//
//  Created by yuu on 2015/11/18.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "IndicatorSource.h"


@interface CandleBaseSource : IndicatorSource

@property (nonatomic, retain) id upColor;
@property (nonatomic, retain) id upLineColor;
@property (nonatomic, retain) id downColor;
@property (nonatomic, retain) id downLineColor;

@end
