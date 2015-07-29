//
//  CandleSource.h
//  FXSimulator
//
//  Created by yuu on 2015/07/27.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
//#import "NSManagedObject.h"

@class NSManagedObject;

@interface CandleSource : NSManagedObject

@property (nonatomic, retain) id downColor;
@property (nonatomic, retain) id downLineColor;
@property (nonatomic, retain) id upColor;
@property (nonatomic, retain) id upLineColor;
@property (nonatomic, retain) NSManagedObject *chartSource;

@end
