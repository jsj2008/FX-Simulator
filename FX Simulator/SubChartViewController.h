//
//  SubChartViewController.h
//  FX Simulator
//
//  Created  on 2014/11/13.
//  
//

#import <UIKit/UIKit.h>
#import "ChartViewController.h"
#import "NewStartViewController.h"

@interface SubChartViewController : UIViewController <ChartViewControllerDelegate, NewStartViewControllerDelegate>
-(void)updatedSaveData;
@end
