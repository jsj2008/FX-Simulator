//
//  SetStartTimeViewController.h
//  FX Simulator
//
//  Created  on 2015/05/02.
//  
//

#import <UIKit/UIKit.h>

@class Time;

typedef void (^SetStartTimeBlock)(Time *startTime);

@interface SetStartTimeViewController : UIViewController
@property (nonatomic) Time *defaultStartTime;
@property (nonatomic, copy) SetStartTimeBlock setStartTime;
@end
