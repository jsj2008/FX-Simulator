//
//  ConfigViewController.h
//  FX Simulator
//
//  Created  on 2014/10/30.
//  
//

#import <UIKit/UIKit.h>
#import "SetAutoUpdateIntervalViewController.h"
#import "SimulationManager.h"

@interface ConfigViewController : UITableViewController < SetAutoUpdateIntervalViewControllerDelegate, SimulationManagerDelegate>
@property (nonatomic) float autoUpdateIntervalSeconds;
@end
