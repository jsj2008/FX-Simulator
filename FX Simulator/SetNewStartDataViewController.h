//
//  SetNewStartDataViewController.h
//  FX Simulator
//
//  Created  on 2015/05/08.
//  
//

#import <UIKit/UIKit.h>

@protocol NewStartViewControllerDelegate;

@interface SetNewStartDataViewController : UIViewController
@property (nonatomic, assign) id<NewStartViewControllerDelegate> delegate;
@end
