//
//  SubChartViewController.h
//  FX Simulator
//
//  Created  on 2014/11/13.
//  
//

#import <UIKit/UIKit.h>
#import "NewStartViewController.h"

@interface SubChartViewController : UIViewController <NewStartViewControllerDelegate>
-(void)updatedSaveData;
@end
