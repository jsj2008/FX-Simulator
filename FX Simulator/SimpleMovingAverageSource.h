//
//  SimpleMovingAverageSource.h
//  FXSimulator
//
//  Created by yuu on 2015/07/27.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "NSManagedObject.h"

@class NSManagedObject;

@interface SimpleMovingAverageSource : NSManagedObject

@property (nonatomic, retain) id lineColor;
@property (nonatomic) int32_t period;
@property (nonatomic, retain) NSManagedObject *chartSource;

@end
