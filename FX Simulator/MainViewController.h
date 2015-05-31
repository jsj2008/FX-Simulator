//
//  MainViewController.h
//  FX Simulator
//
//  Created  on 2014/10/30.
//  
//

#import <UIKit/UIKit.h>
#import "NewStartViewController.h"

@interface MainViewController : UITabBarController <NewStartViewControllerDelegate>
-(void)updatedSaveData;
@end
