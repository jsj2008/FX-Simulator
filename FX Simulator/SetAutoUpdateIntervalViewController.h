//
//  SetAutoUpdateIntervalViewController.h
//  FX Simulator
//
//  Created  on 2015/05/16.
//  
//

#import <UIKit/UIKit.h>

@protocol SetAutoUpdateIntervalViewControllerDelegate
@property (nonatomic, readwrite) NSNumber *autoUpdateInterval;
@end

@interface SetAutoUpdateIntervalViewController : UIViewController
@property (nonatomic, assign) id<SetAutoUpdateIntervalViewControllerDelegate> delegate;
@end
