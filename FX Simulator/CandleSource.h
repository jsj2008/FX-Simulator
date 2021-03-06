//
//  CandleSource.h
//  FXSimulator
//
//  Created by yuu on 2015/11/18.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CandleBaseSource.h"

@class ChartSource;

@interface CandleSource : CandleBaseSource

@property (nonatomic, retain) ChartSource *chartSource;

@end
