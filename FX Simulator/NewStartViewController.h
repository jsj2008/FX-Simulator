//
//  NewStartViewController.h
//  FX Simulator
//
//  Created  on 2015/04/26.
//  
//

#import <UIKit/UIKit.h>
#import "SimulationManager.h"

@protocol NewStartViewControllerDelegate <NSObject>
- (void)didStartSimulationWithNewData;
@end

@interface NewStartViewController : UITableViewController <SimulationManagerDelegate>
@property (nonatomic, weak) id<NewStartViewControllerDelegate> delegate;
@end
