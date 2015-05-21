//
//  SetAutoUpdateIntervalViewController.h
//  FX Simulator
//
//  Created  on 2015/05/16.
//  
//

#import <UIKit/UIKit.h>

@protocol ConfigViewControllerDelegate;

@interface SetAutoUpdateIntervalViewController : UIViewController
@property (nonatomic, assign) id<ConfigViewControllerDelegate> delegate;
@end
